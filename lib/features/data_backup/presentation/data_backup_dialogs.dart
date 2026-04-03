import 'package:flutter/material.dart';

import '../../../shared/widgets/pp_dialog.dart';
import '../domain/data_backup_entry.dart';

Future<bool> showRestoreBackupDialog(BuildContext context) async {
  return showPPConfirmDialog(
    context,
    title: '从备份文件恢复？',
    message: '接下来会打开系统文件选择器。选中的备份文件将覆盖当前本地配置。',
    confirmLabel: '恢复',
    icon: Icons.settings_backup_restore_rounded,
  );
}

Future<bool> showDeleteBackupDialog(
  BuildContext context,
  DataBackupEntry entry,
) async {
  return showPPConfirmDialog(
    context,
    title: '删除这个备份记录？',
    message: '将从列表中移除 ${entry.fileName} 的本地记录，外部备份文件需在系统文件管理器中自行删除。',
    confirmLabel: '删除',
    icon: Icons.delete_outline_rounded,
    tone: PPDialogTone.destructive,
  );
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
