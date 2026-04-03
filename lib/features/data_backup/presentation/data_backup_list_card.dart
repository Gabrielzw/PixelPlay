import 'package:flutter/material.dart';

import '../../../shared/widgets/settings/settings_shell.dart';
import '../domain/data_backup_entry.dart';
import 'data_backup_dialogs.dart';

class DataBackupListCard extends StatelessWidget {
  final bool isBusy;
  final bool isLoading;
  final String? errorMessage;
  final List<DataBackupEntry> entries;
  final String? processingBackupId;
  final VoidCallback onRetry;
  final ValueChanged<DataBackupEntry> onDelete;

  const DataBackupListCard({
    super.key,
    required this.isBusy,
    required this.isLoading,
    required this.errorMessage,
    required this.entries,
    required this.processingBackupId,
    required this.onRetry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SettingsPanel(
        child: SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (errorMessage case final String message) {
      return SettingsPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('备份列表加载失败', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (entries.isEmpty) {
      return const SettingsPanel(
        child: SettingsEmptyState(
          icon: Icons.inventory_2_outlined,
          title: '暂无备份',
          description: '创建一次备份后，这里会显示已导出的备份记录。',
        ),
      );
    }

    return Column(
      children: entries
          .map((DataBackupEntry entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _BackupEntryCard(
                entry: entry,
                isProcessing: processingBackupId == entry.id,
                isDisabled: isBusy && processingBackupId != entry.id,
                onDelete: () {
                  onDelete(entry);
                },
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

class _BackupEntryCard extends StatelessWidget {
  final DataBackupEntry entry;
  final bool isProcessing;
  final bool isDisabled;
  final VoidCallback onDelete;

  const _BackupEntryCard({
    required this.entry,
    required this.isProcessing,
    required this.isDisabled,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            formatBackupDateTime(entry.createdAt),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(entry.fileName),
          const SizedBox(height: 4),
          Text(entry.filePath, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _CountChip(label: 'WebDAV ${entry.webDavAccountCount}'),
              _CountChip(label: '收藏夹 ${entry.favoriteFolderCount}'),
              _CountChip(label: '列表 ${entry.playlistSourceCount}'),
              _CountChip(label: '备份记录 ${entry.backupRecordCount}'),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: isProcessing || isDisabled ? null : onDelete,
              icon: isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline_rounded),
              label: Text(isProcessing ? '处理中...' : '删除记录'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;

  const _CountChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant)),
    );
  }
}
