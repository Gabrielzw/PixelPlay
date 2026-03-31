import 'package:flutter/material.dart';

import '../domain/data_backup_entry.dart';

Future<bool> showRestoreBackupDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('从备份文件恢复？'),
        content: const Text('接下来会打开系统文件选择器。选中的备份文件将覆盖当前本地配置。'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('恢复'),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

Future<bool> showDeleteBackupDialog(
  BuildContext context,
  DataBackupEntry entry,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('删除这个备份记录？'),
        content: Text('将从列表中移除 ${entry.fileName} 的本地记录，外部备份文件需在系统文件管理器中自行删除。'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

String formatBackupDateTime(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  final second = value.second.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute:$second';
}
