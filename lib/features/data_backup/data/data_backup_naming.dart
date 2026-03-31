String buildDataBackupId(DateTime value) {
  return 'backup-${value.microsecondsSinceEpoch}';
}

String buildDataBackupFileName(DateTime value, String backupId) {
  final suffix = backupId.split('-').last;
  return 'pixelplay-backup-${_formatTimestamp(value)}-$suffix.json';
}

String _formatTimestamp(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  final second = value.second.toString().padLeft(2, '0');
  return '$year$month$day-$hour$minute$second';
}
