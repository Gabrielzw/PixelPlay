import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/page_navigation.dart';
import '../../data_backup/presentation/data_backup_page.dart';
import '../domain/page_transition_type.dart';
import '../domain/settings_controller.dart';
import 'cache_settings_page.dart';
import 'player_settings_page.dart';
import 'theme_settings_page.dart';
import 'transition_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsScaffold();
  }
}

class _SettingsScaffold extends StatelessWidget {
  const _SettingsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends GetView<SettingsController> {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = controller.settings.value;

      return ListView(
        key: const PageStorageKey<String>('settings_list'),
        padding: const EdgeInsets.only(bottom: 16),
        children: <Widget>[
          _SettingsSection(
            title: '外观',
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('主题与主色'),
                subtitle: const Text('跟随系统 / 浅色 / 深色 / 主色'),
                onTap: () => pushRootPage<void>(
                  context,
                  (_) => const ThemeSettingsPage(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.animation_outlined),
                title: const Text('页面切换动画'),
                subtitle: Text(settings.pageTransitionType.label),
                onTap: () => pushRootPage<void>(
                  context,
                  (_) => const TransitionSettingsPage(),
                ),
              ),
            ],
          ),
          _SettingsSection(
            title: '播放',
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('播放器默认设置'),
                subtitle: const Text('倍速 / 画面比例 / 手势快进 / 续播'),
                onTap: () => pushRootPage<void>(
                  context,
                  (_) => const PlayerSettingsPage(),
                ),
              ),
            ],
          ),
          _SettingsSection(
            title: '存储',
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.cached_outlined),
                title: const Text('缓存'),
                subtitle: const Text('缩略图与播放相关缓存'),
                onTap: () => pushRootPage<void>(
                  context,
                  (_) => const CacheSettingsPage(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.backup_table_outlined),
                title: const Text('数据备份与恢复'),
                subtitle: const Text('备份设置、云盘账户、收藏夹和备份列表'),
                onTap: () => pushRootPage<void>(
                  context,
                  (_) => const DataBackupPage(),
                ),
              ),
            ],
          ),
          _SettingsSection(
            title: '关于',
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('开源许可证'),
                subtitle: const Text('查看应用使用的开源许可信息'),
                onTap: () => pushRootPage<void>(
                  context,
                  (_) => const LicensePage(applicationName: 'Pixel Play'),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
