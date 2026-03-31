import 'package:isar_community/isar.dart';

import '../../../../features/data_backup/domain/data_backup_entry.dart';

part 'data_backup_record_isar_model.g.dart';

@collection
class DataBackupRecordIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String backupId;

  String? filePath;
  late String fileName;
  late int createdAtMs;
  late int schemaVersion;
  late int webDavAccountCount;
  late int favoriteFolderCount;
  late int playlistSourceCount;
  late int backupRecordCount;

  DataBackupEntry toDomain() {
    final resolvedFilePath = filePath ?? fileName;
    return DataBackupEntry(
      id: backupId,
      filePath: resolvedFilePath,
      fileName: resolveDataBackupFileName(resolvedFilePath),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      schemaVersion: schemaVersion,
      webDavAccountCount: webDavAccountCount,
      favoriteFolderCount: favoriteFolderCount,
      playlistSourceCount: playlistSourceCount,
      backupRecordCount: backupRecordCount,
    );
  }

  static DataBackupRecordIsarModel fromDomain(DataBackupEntry entry) {
    return DataBackupRecordIsarModel()
      ..backupId = entry.id
      ..filePath = entry.filePath
      ..fileName = entry.fileName
      ..createdAtMs = entry.createdAt.millisecondsSinceEpoch
      ..schemaVersion = entry.schemaVersion
      ..webDavAccountCount = entry.webDavAccountCount
      ..favoriteFolderCount = entry.favoriteFolderCount
      ..playlistSourceCount = entry.playlistSourceCount
      ..backupRecordCount = entry.backupRecordCount;
  }
}
