import 'package:flutter/foundation.dart';

import '../../favorites/presentation/favorite_models.dart';
import '../../playlist_sources/presentation/playlist_source_models.dart';
import '../../settings/domain/app_settings.dart';
import '../../webdav_client/domain/webdav_server_config.dart';
import '../domain/data_backup_entry.dart';

const int kDataBackupSchemaVersion = 1;

@immutable
class DataBackupSnapshot {
  final int schemaVersion;
  final String backupId;
  final DateTime createdAt;
  final AppSettings appSettings;
  final List<WebDavServerConfig> webDavAccounts;
  final List<FavoriteFolderEntry> favoriteFolders;
  final List<PlaylistSourceEntry> playlistSources;
  final List<DataBackupEntry> backupRecords;
  final Map<String, String> secureStorageEntries;

  DataBackupSnapshot({
    required this.schemaVersion,
    required this.backupId,
    required this.createdAt,
    required this.appSettings,
    required List<WebDavServerConfig> webDavAccounts,
    required List<FavoriteFolderEntry> favoriteFolders,
    required List<PlaylistSourceEntry> playlistSources,
    required List<DataBackupEntry> backupRecords,
    required Map<String, String> secureStorageEntries,
  }) : webDavAccounts = List<WebDavServerConfig>.unmodifiable(webDavAccounts),
       favoriteFolders = List<FavoriteFolderEntry>.unmodifiable(
         favoriteFolders,
       ),
       playlistSources = List<PlaylistSourceEntry>.unmodifiable(
         playlistSources,
       ),
       backupRecords = List<DataBackupEntry>.unmodifiable(backupRecords),
       secureStorageEntries = Map<String, String>.unmodifiable(
         secureStorageEntries,
       );

  DataBackupSnapshot copyWith({List<DataBackupEntry>? backupRecords}) {
    return DataBackupSnapshot(
      schemaVersion: schemaVersion,
      backupId: backupId,
      createdAt: createdAt,
      appSettings: appSettings,
      webDavAccounts: webDavAccounts,
      favoriteFolders: favoriteFolders,
      playlistSources: playlistSources,
      backupRecords: backupRecords ?? this.backupRecords,
      secureStorageEntries: secureStorageEntries,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'schemaVersion': schemaVersion,
      'backupId': backupId,
      'createdAtMs': createdAt.millisecondsSinceEpoch,
      'appSettings': appSettings.toJson(),
      'webDavAccounts': webDavAccounts
          .map((WebDavServerConfig account) => account.toJson())
          .toList(growable: false),
      'favoriteFolders': favoriteFolders
          .map((FavoriteFolderEntry folder) => folder.toJson())
          .toList(growable: false),
      'playlistSources': playlistSources
          .map((PlaylistSourceEntry entry) => entry.toJson())
          .toList(growable: false),
      'backupRecords': backupRecords
          .map((DataBackupEntry entry) => entry.toJson())
          .toList(growable: false),
      'secureStorageEntries': secureStorageEntries,
    };
  }

  factory DataBackupSnapshot.fromJson(Map<String, Object?> json) {
    final schemaVersion = (json['schemaVersion'] as num?)?.toInt();
    if (schemaVersion != kDataBackupSchemaVersion) {
      throw StateError('不支持的备份版本：$schemaVersion');
    }

    return DataBackupSnapshot(
      schemaVersion: schemaVersion!,
      backupId: json['backupId']! as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (json['createdAtMs'] as num).toInt(),
      ),
      appSettings: AppSettings.fromJson(
        Map<String, Object?>.from(
          json['appSettings']! as Map<Object?, Object?>,
        ),
      ),
      webDavAccounts: _decodeList<WebDavServerConfig>(
        json['webDavAccounts'] as List<Object?>?,
        (Object? item) => WebDavServerConfig.fromJson(
          Map<String, Object?>.from(item! as Map<Object?, Object?>),
        ),
      ),
      favoriteFolders: _decodeList<FavoriteFolderEntry>(
        json['favoriteFolders'] as List<Object?>?,
        (Object? item) => FavoriteFolderEntry.fromJson(
          Map<String, Object?>.from(item! as Map<Object?, Object?>),
        ),
      ),
      playlistSources: _decodeList<PlaylistSourceEntry>(
        json['playlistSources'] as List<Object?>?,
        (Object? item) => PlaylistSourceEntry.fromJson(
          Map<String, Object?>.from(item! as Map<Object?, Object?>),
        ),
      ),
      backupRecords: _decodeList<DataBackupEntry>(
        json['backupRecords'] as List<Object?>?,
        (Object? item) => DataBackupEntry.fromJson(
          Map<String, Object?>.from(item! as Map<Object?, Object?>),
        ),
      ),
      secureStorageEntries: Map<String, String>.from(
        json['secureStorageEntries'] as Map<Object?, Object?>? ??
            const <Object?, Object?>{},
      ),
    );
  }
}

List<T> _decodeList<T>(List<Object?>? values, T Function(Object? item) decode) {
  final source = values ?? const <Object?>[];
  return source.map(decode).toList(growable: false);
}
