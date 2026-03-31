abstract interface class DataBackupFilePort {
  Future<String?> saveBackupFile({
    required String suggestedFileName,
    required String content,
  });

  Future<String?> pickBackupFile();
}
