import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/pp_dialog.dart';
import '../../../shared/widgets/pp_toast.dart';
import '../../../shared/widgets/settings/settings_shell.dart';
import '../domain/cache_settings_controller.dart';

const double kCacheActionProgressSize = 20;

class CacheSettingsPage extends GetView<CacheSettingsController> {
  const CacheSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isClearing = controller.isClearing.value;

      return SettingsDetailScaffold(
        title: '缓存设置',
        child: ListView(
          padding: kSettingsPagePadding,
          children: <Widget>[
            const SettingsSectionTitle('缓存管理'),
            SettingsListItem(
              title: isClearing ? '正在清理缓存' : '清理缓存',
              subtitle: '将清除缩略图缓存与播放进度记录',
              trailing: isClearing
                  ? const SizedBox(
                      width: kCacheActionProgressSize,
                      height: kCacheActionProgressSize,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onTap: isClearing ? null : () => _handleClearCache(context),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _handleClearCache(BuildContext context) async {
    final confirmed = await _showClearCacheConfirmation(context);
    if (!confirmed || !context.mounted) {
      return;
    }

    unawaited(PPToast.showLoading(msg: '正在清理缓存...'));
    try {
      await controller.clearCache();
      await PPToast.dismissLoading();
      await PPToast.success('缓存已清理');
    } catch (error) {
      await PPToast.dismissLoading();
      await PPToast.error(error.toString());
    }
  }
}

Future<bool> _showClearCacheConfirmation(BuildContext context) async {
  return showPPConfirmDialog(
    context,
    title: '清理缓存？',
    message: '这会删除已生成的缩略图缓存，并清空播放进度记录。',
    confirmLabel: '清理',
    icon: Icons.cleaning_services_rounded,
    tone: PPDialogTone.destructive,
  );
}
