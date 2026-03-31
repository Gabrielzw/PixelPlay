import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/pp_toast.dart';
import '../domain/cache_settings_controller.dart';

const double kCacheActionProgressSize = 20;

class CacheSettingsPage extends GetView<CacheSettingsController> {
  const CacheSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CacheSettingsScaffold();
  }
}

class _CacheSettingsScaffold extends StatelessWidget {
  const _CacheSettingsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('缓存')),
      body: const _CacheSettingsBody(),
    );
  }
}

class _CacheSettingsBody extends GetView<CacheSettingsController> {
  const _CacheSettingsBody();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isClearing = controller.isClearing.value;

      return ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(isClearing ? '正在清理缓存' : '清理缓存'),
              subtitle: const Text('将清除缩略图缓存与播放进度'),
              trailing: isClearing
                  ? const SizedBox(
                      width: kCacheActionProgressSize,
                      height: kCacheActionProgressSize,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              enabled: !isClearing,
              onTap: isClearing ? null : () => _handleClearCache(context),
            ),
          ),
        ],
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
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('清理缓存？'),
        content: const Text('这会删除已生成的缩略图缓存，并清空播放进度记录。'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('清理'),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
