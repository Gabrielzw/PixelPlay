import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/pp_toast.dart';
import '../../../shared/widgets/settings/settings_shell.dart';
import '../domain/data_backup_controller.dart';
import '../domain/data_backup_entry.dart';
import 'data_backup_dialogs.dart';
import 'data_backup_list_card.dart';

const double kBackupActionProgressSize = 20;

class DataBackupPage extends GetView<DataBackupController> {
  const DataBackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsDetailScaffold(
      title: '数据备份与恢复',
      child: Obx(() {
        final isCreating = controller.isCreating.value;
        final processingBackupId = controller.processingBackupId.value;
        final isBusy = isCreating || processingBackupId != null;
        final isRestoring = processingBackupId == kRestoreProcessingToken;

        return ListView(
          padding: kSettingsPagePadding,
          children: <Widget>[
            const SettingsSectionTitle('备份说明'),
            const _BackupScopePanel(),
            const SizedBox(height: kSettingsSectionSpacing),
            const SettingsSectionTitle('备份操作'),
            SettingsListItem(
              title: '创建本地备份',
              subtitle: '通过系统文件选择器选择保存位置，并生成新的配置快照',
              trailing: isCreating
                  ? const SizedBox(
                      width: kBackupActionProgressSize,
                      height: kBackupActionProgressSize,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onTap: isBusy ? null : () => _handleCreateBackup(context),
            ),
            SettingsListItem(
              title: '从备份文件恢复',
              subtitle: '通过系统文件选择器挑选备份文件并恢复配置',
              trailing: isRestoring
                  ? const SizedBox(
                      width: kBackupActionProgressSize,
                      height: kBackupActionProgressSize,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onTap: isBusy ? null : () => _handleRestoreBackup(context),
            ),
            const SizedBox(height: kSettingsSectionSpacing),
            const SettingsSectionTitle('备份记录'),
            DataBackupListCard(
              isBusy: isBusy,
              isLoading: controller.isLoading.value,
              errorMessage: controller.errorMessage.value,
              entries: controller.backups,
              processingBackupId: processingBackupId,
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

class _BackupScopePanel extends StatelessWidget {
  const _BackupScopePanel();

  @override
  Widget build(BuildContext context) {
    return const SettingsPanel(
      child: Text(
        '包含设置项、WebDAV 账户与密码、收藏夹、播放列表来源，以及当前备份列表等本地持久化配置。'
        '备份和恢复都会通过系统文件选择器完成。',
      ),
    );
  }
}
