import 'data_backup_entry.dart';

abstract interface class DataBackupRepository {
  Future<List<DataBackupEntry>> loadBackups();

  Future<DataBackupEntry?> createBackup();

  Future<bool> restoreBackup();

  Future<void> deleteBackup(String backupId);
}
