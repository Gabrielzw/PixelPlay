import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/pp_toast.dart';
import '../domain/data_backup_controller.dart';
import '../domain/data_backup_entry.dart';
import 'data_backup_dialogs.dart';
import 'data_backup_list_card.dart';

class DataBackupPage extends GetView<DataBackupController> {
  const DataBackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('数据备份与恢复')),
      body: Obx(() {
        final isBusy =
            controller.isCreating.value ||
            controller.processingBackupId.value != null;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const _BackupScopeCard(),
            const SizedBox(height: 12),
            _CreateBackupCard(
              isBusy: isBusy,
              onPressed: () {
                _handleCreateBackup(context);
              },
            ),
            const SizedBox(height: 12),
            _RestoreBackupCard(
              isBusy: isBusy,
              onPressed: () {
                _handleRestoreBackup(context);
              },
            ),
            const SizedBox(height: 12),
            DataBackupListCard(
              isBusy: isBusy,
              isLoading: controller.isLoading.value,
              errorMessage: controller.errorMessage.value,
              entries: controller.backups,
              processingBackupId: controller.processingBackupId.value,
              onRetry: () {
                controller.refreshBackups();
              },
              onDelete: (DataBackupEntry entry) {
                _handleDeleteBackup(context, entry);
              },
            ),
          ],
        );
      }),
    );
  }

  Future<void> _handleCreateBackup(BuildContext context) async {
    try {
      final created = await controller.createBackup();
      if (created) {
        await PPToast.success('备份已创建');
      }
    } catch (error) {
      await PPToast.error(error.toString());
    }
  }

  Future<void> _handleRestoreBackup(BuildContext context) async {
    final confirmed = await showRestoreBackupDialog(context);
    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      final restored = await controller.restoreBackup();
      if (restored) {
        await PPToast.success('备份已恢复');
      }
    } catch (error) {
      await PPToast.error(error.toString());
    }
  }

  Future<void> _handleDeleteBackup(
    BuildContext context,
    DataBackupEntry entry,
  ) async {
    final confirmed = await showDeleteBackupDialog(context, entry);
    if (!confirmed || !context.mounted) {
      return;
    }

    await PPToast.showLoading(msg: '正在删除备份...');
    try {
      await controller.deleteBackup(entry.id);
      await PPToast.dismissLoading();
      await PPToast.success('备份已删除');
    } catch (error) {
      await PPToast.dismissLoading();
      await PPToast.error(error.toString());
    }
  }
}

class _BackupScopeCard extends StatelessWidget {
  const _BackupScopeCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('备份范围'),
            SizedBox(height: 8),
            Text(
              '包含设置项、WebDAV 账户与密码、收藏夹、播放列表来源，以及当前备份列表等本地持久化配置。备份和恢复都会通过系统文件选择器完成。',
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateBackupCard extends StatelessWidget {
  final bool isBusy;
  final VoidCallback onPressed;

  const _CreateBackupCard({required this.isBusy, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.backup_outlined),
        title: const Text('创建本地备份'),
        subtitle: const Text('通过系统文件选择器选择保存位置，并生成新的配置快照。'),
        trailing: isBusy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
        enabled: !isBusy,
        onTap: isBusy ? null : onPressed,
      ),
    );
  }
}

class _RestoreBackupCard extends StatelessWidget {
  final bool isBusy;
  final VoidCallback onPressed;

  const _RestoreBackupCard({required this.isBusy, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.restore_page_outlined),
        title: const Text('从备份文件恢复'),
        subtitle: const Text('通过系统文件选择器挑选备份文件并恢复配置。'),
        trailing: isBusy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
        enabled: !isBusy,
        onTap: isBusy ? null : onPressed,
      ),
    );
  }
}
