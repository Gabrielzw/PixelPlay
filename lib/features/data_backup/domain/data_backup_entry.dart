import 'package:flutter/foundation.dart';

@immutable
class DataBackupEntry {
  final String id;
  final String filePath;
  final String fileName;
  final DateTime createdAt;
  final int schemaVersion;
  final int webDavAccountCount;
  final int favoriteFolderCount;
  final int playlistSourceCount;
  final int backupRecordCount;

  const DataBackupEntry({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.createdAt,
    required this.schemaVersion,
    required this.webDavAccountCount,
    required this.favoriteFolderCount,
    required this.playlistSourceCount,
    required this.backupRecordCount,
  });

  DataBackupEntry copyWith({String? filePath, String? fileName}) {
    return DataBackupEntry(
      id: id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      createdAt: createdAt,
      schemaVersion: schemaVersion,
      webDavAccountCount: webDavAccountCount,
      favoriteFolderCount: favoriteFolderCount,
      playlistSourceCount: playlistSourceCount,
      backupRecordCount: backupRecordCount,
    );
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'id': id,
      'filePath': filePath,
      'fileName': fileName,
      'createdAtMs': createdAt.millisecondsSinceEpoch,
      'schemaVersion': schemaVersion,
      'webDavAccountCount': webDavAccountCount,
      'favoriteFolderCount': favoriteFolderCount,
      'playlistSourceCount': playlistSourceCount,
      'backupRecordCount': backupRecordCount,
    };
  }

  factory DataBackupEntry.fromJson(Map<String, Object?> json) {
    final storedFilePath =
        json['filePath'] as String? ?? json['fileName']! as String;
    return DataBackupEntry(
      id: json['id']! as String,
      filePath: storedFilePath,
      fileName: _resolveFileName(
        filePath: storedFilePath,
        fallback: json['fileName'] as String?,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (json['createdAtMs'] as num).toInt(),
      ),
      schemaVersion: (json['schemaVersion'] as num).toInt(),
      webDavAccountCount: (json['webDavAccountCount'] as num).toInt(),
      favoriteFolderCount: (json['favoriteFolderCount'] as num).toInt(),
      playlistSourceCount: (json['playlistSourceCount'] as num).toInt(),
      backupRecordCount: (json['backupRecordCount'] as num).toInt(),
    );
  }
}

String resolveDataBackupFileName(String filePath) {
  final normalizedPath = filePath.replaceAll('\\', '/');
  final segments = normalizedPath
      .split('/')
      .where((String item) {
        return item.isNotEmpty;
      })
      .toList(growable: false);
  if (segments.isEmpty) {
    return filePath;
  }
  return segments.last;
}

String _resolveFileName({required String filePath, required String? fallback}) {
  if (fallback case final String value when value.trim().isNotEmpty) {
    return value;
  }
  return resolveDataBackupFileName(filePath);
}
