import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';

class CacheSettingsPage extends StatelessWidget {
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

class _CacheSettingsBody extends StatelessWidget {
  const _CacheSettingsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const UiSkeletonNotice(message: 'UI 骨架阶段：缩略图缓存路径与清理策略尚未接入。'),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('清理缓存'),
            subtitle: const Text('将清除缩略图与播放相关缓存'),
            onTap: () => showNotImplementedSnackBar(context, '清理缓存（未接入）'),
          ),
        ),
      ],
    );
  }
}
