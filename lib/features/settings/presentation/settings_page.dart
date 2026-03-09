import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/page_navigation.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
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
          const UiSkeletonNotice(message: '主题、动效与播放偏好会自动保存。'),
          const SizedBox(height: 12),
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
