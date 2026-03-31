import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';

import '../../../shared/data/isar/schemas/app_settings_isar_model.dart';
import '../../../shared/data/isar/schemas/data_backup_record_isar_model.dart';
import '../../../shared/data/isar/schemas/favorite_folder_isar_model.dart';
import '../../../shared/data/isar/schemas/playlist_source_isar_model.dart';
import '../../../shared/data/isar/schemas/webdav_account_isar_model.dart';
import '../../favorites/presentation/favorite_models.dart';
import '../../playlist_sources/presentation/playlist_source_models.dart';
import '../../settings/domain/app_settings.dart';
import '../../webdav_client/domain/webdav_server_config.dart';
import '../domain/data_backup_entry.dart';
import '../domain/data_backup_file_port.dart';
import '../domain/data_backup_repository.dart';
import 'data_backup_naming.dart';
import 'data_backup_snapshot.dart';

const JsonEncoder _backupJsonEncoder = JsonEncoder.withIndent('  ');

class SystemFileDialogDataBackupRepository implements DataBackupRepository {
  final Isar isar;
  final FlutterSecureStorage secureStorage;
  final DataBackupFilePort filePort;

  const SystemFileDialogDataBackupRepository({
    required this.isar,
    required this.secureStorage,
    required this.filePort,
  });

  @override
  Future<List<DataBackupEntry>> loadBackups() async {
    final records = await isar.dataBackupRecordIsarModels.where().findAll();
    final entries = records
        .map((DataBackupRecordIsarModel record) => record.toDomain())
        .toList(growable: false);
    entries.sort(
      (DataBackupEntry left, DataBackupEntry right) =>
          right.createdAt.compareTo(left.createdAt),
    );
    return List<DataBackupEntry>.unmodifiable(entries);
  }

  @override
  Future<DataBackupEntry?> createBackup() async {
    final createdAt = DateTime.now();
    final backupId = buildDataBackupId(createdAt);
    final suggestedFileName = buildDataBackupFileName(createdAt, backupId);
    final draftEntry = await _buildCurrentEntry(
      backupId: backupId,
      filePath: suggestedFileName,
      createdAt: createdAt,
    );
    final snapshot = await _buildSnapshot(currentEntry: draftEntry);
    final savedFilePath = await filePort.saveBackupFile(
      suggestedFileName: suggestedFileName,
      content: _backupJsonEncoder.convert(snapshot.toJson()),
    );
    if (savedFilePath == null) {
      return null;
    }

    final actualEntry = draftEntry.copyWith(
      filePath: savedFilePath,
      fileName: resolveDataBackupFileName(savedFilePath),
    );
    await _saveBackupRecord(actualEntry);
    return actualEntry;
  }

  @override
  Future<bool> restoreBackup() async {
    final pickedFilePath = await filePort.pickBackupFile();
    if (pickedFilePath == null) {
      return false;
    }

    final snapshot = await _readSnapshot(pickedFilePath);
    final patchedSnapshot = _patchPickedFileRecord(
      snapshot: snapshot,
      pickedFilePath: pickedFilePath,
    );
    await _restoreCollections(patchedSnapshot);
    await _restoreSecureStorage(patchedSnapshot.secureStorageEntries);
    return true;
  }

  @override
  Future<void> deleteBackup(String backupId) async {
    final record = await _findBackupRecord(backupId);
    if (record == null) {
      throw StateError('未找到备份记录：$backupId');
    }

    await isar.writeTxn(() async {
      await isar.dataBackupRecordIsarModels.delete(record.id);
    });
  }

  Future<DataBackupEntry> _buildCurrentEntry({
    required String backupId,
    required String filePath,
    required DateTime createdAt,
  }) async {
    final favoriteFolders = _loadFavoriteFolders();
    final playlistSources = _loadPlaylistSources();
    final webDavAccounts = await _loadWebDavAccounts();
    final storedEntries = await _loadStoredBackupEntries();
    return DataBackupEntry(
      id: backupId,
      filePath: filePath,
      fileName: resolveDataBackupFileName(filePath),
      createdAt: createdAt,
      schemaVersion: kDataBackupSchemaVersion,
      webDavAccountCount: webDavAccounts.length,
      favoriteFolderCount: favoriteFolders.length,
      playlistSourceCount: playlistSources.length,
      backupRecordCount: storedEntries.length + 1,
    );
  }

  Future<DataBackupSnapshot> _buildSnapshot({
    required DataBackupEntry currentEntry,
  }) async {
    final storedEntries = await _loadStoredBackupEntries();
    return DataBackupSnapshot(
      schemaVersion: kDataBackupSchemaVersion,
      backupId: currentEntry.id,
      createdAt: currentEntry.createdAt,
      appSettings: _loadAppSettings(),
      webDavAccounts: await _loadWebDavAccounts(),
      favoriteFolders: _loadFavoriteFolders(),
      playlistSources: _loadPlaylistSources(),
      backupRecords: <DataBackupEntry>[...storedEntries, currentEntry],
      secureStorageEntries: await secureStorage.readAll(),
    );
  }

  AppSettings _loadAppSettings() {
    final storedSettings = isar.appSettingsIsarModels.getSync(
      kAppSettingsSingletonId,
    );
    return storedSettings?.toDomain() ?? const AppSettings();
  }

  List<FavoriteFolderEntry> _loadFavoriteFolders() {
    return isar.favoriteFolderIsarModels
        .where()
        .findAllSync()
        .map((FavoriteFolderIsarModel folder) => folder.toDomain())
        .toList(growable: false);
  }

  List<PlaylistSourceEntry> _loadPlaylistSources() {
    return isar.playlistSourceIsarModels
        .where()
        .findAllSync()
        .map((PlaylistSourceIsarModel entry) => entry.toDomain())
        .toList(growable: false);
  }

  Future<List<WebDavServerConfig>> _loadWebDavAccounts() async {
    final accounts = await isar.webDavAccountIsarModels.where().findAll();
    return accounts
        .map((WebDavAccountIsarModel account) => account.toDomain())
        .toList(growable: false);
  }

  Future<List<DataBackupEntry>> _loadStoredBackupEntries() async {
    final records = await isar.dataBackupRecordIsarModels.where().findAll();
    return records
        .map((DataBackupRecordIsarModel record) => record.toDomain())
        .toList(growable: false);
  }

  Future<void> _saveBackupRecord(DataBackupEntry entry) async {
    await isar.writeTxn(() async {
      await isar.dataBackupRecordIsarModels.put(
        DataBackupRecordIsarModel.fromDomain(entry),
      );
    });
  }

  Future<DataBackupRecordIsarModel?> _findBackupRecord(String backupId) {
    return isar.dataBackupRecordIsarModels
        .filter()
        .backupIdEqualTo(backupId)
        .findFirst();
  }

  Future<DataBackupSnapshot> _readSnapshot(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw StateError('备份文件不存在：$filePath');
    }

    final content = await file.readAsString();
    final decoded = jsonDecode(content);
    return DataBackupSnapshot.fromJson(
      Map<String, Object?>.from(decoded as Map<Object?, Object?>),
    );
  }

  DataBackupSnapshot _patchPickedFileRecord({
    required DataBackupSnapshot snapshot,
    required String pickedFilePath,
  }) {
    final pickedFileName = resolveDataBackupFileName(pickedFilePath);
    final patchedRecords = snapshot.backupRecords
        .map((DataBackupEntry entry) {
          if (entry.id != snapshot.backupId) {
            return entry;
          }
          return entry.copyWith(
            filePath: pickedFilePath,
            fileName: pickedFileName,
          );
        })
        .toList(growable: true);
    if (_containsBackupRecord(patchedRecords, snapshot.backupId)) {
      return snapshot.copyWith(backupRecords: patchedRecords);
    }

    patchedRecords.add(
      DataBackupEntry(
        id: snapshot.backupId,
        filePath: pickedFilePath,
        fileName: pickedFileName,
        createdAt: snapshot.createdAt,
        schemaVersion: snapshot.schemaVersion,
        webDavAccountCount: snapshot.webDavAccounts.length,
        favoriteFolderCount: snapshot.favoriteFolders.length,
        playlistSourceCount: snapshot.playlistSources.length,
        backupRecordCount: snapshot.backupRecords.length + 1,
      ),
    );
    return snapshot.copyWith(backupRecords: patchedRecords);
  }

  bool _containsBackupRecord(List<DataBackupEntry> entries, String backupId) {
    for (final DataBackupEntry entry in entries) {
      if (entry.id == backupId) {
        return true;
      }
    }
    return false;
  }

  Future<void> _restoreCollections(DataBackupSnapshot snapshot) async {
    final favoriteFolderModels = snapshot.favoriteFolders
        .map(FavoriteFolderIsarModel.fromDomain)
        .toList(growable: false);
    final playlistSourceModels = snapshot.playlistSources
        .map(PlaylistSourceIsarModel.fromDomain)
        .toList(growable: false);
    final webDavAccountModels = snapshot.webDavAccounts
        .map(WebDavAccountIsarModel.fromDomain)
        .toList(growable: false);
    final backupRecordModels = snapshot.backupRecords
        .map(DataBackupRecordIsarModel.fromDomain)
        .toList(growable: false);

    await isar.writeTxn(() async {
      await isar.appSettingsIsarModels.put(
        AppSettingsIsarModel.fromDomain(snapshot.appSettings),
      );
      await isar.favoriteFolderIsarModels.clear();
      await isar.playlistSourceIsarModels.clear();
      await isar.webDavAccountIsarModels.clear();
      await isar.dataBackupRecordIsarModels.clear();
      await isar.favoriteFolderIsarModels.putAll(favoriteFolderModels);
      await isar.playlistSourceIsarModels.putAll(playlistSourceModels);
      await isar.webDavAccountIsarModels.putAll(webDavAccountModels);
      await isar.dataBackupRecordIsarModels.putAll(backupRecordModels);
    });
  }

  Future<void> _restoreSecureStorage(Map<String, String> entries) async {
    await secureStorage.deleteAll();
    for (final MapEntry<String, String> entry in entries.entries) {
      await secureStorage.write(key: entry.key, value: entry.value);
    }
  }
}
