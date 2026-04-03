import 'package:flutter/material.dart';

import '../../../features/data_backup/presentation/data_backup_page.dart';
import '../domain/app_settings.dart';
import '../domain/page_transition_type.dart';
import 'about_settings_page.dart';
import 'cache_settings_page.dart';
import 'player_settings_page.dart';
import 'theme_settings_page.dart';
import 'transition_settings_page.dart';

typedef SettingsPageFactory = Widget Function();

@immutable
class SettingsMenuEntry {
  final IconData icon;
  final String title;
  final String subtitle;
  final SettingsPageFactory pageFactory;

  const SettingsMenuEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.pageFactory,
  });
}

@immutable
class SettingsSearchEntry {
  final String title;
  final String description;
  final String section;
  final List<String> keywords;
  final SettingsPageFactory pageFactory;
  final String? Function(AppSettings settings)? valueBuilder;

  const SettingsSearchEntry({
    required this.title,
    required this.description,
    required this.section,
    required this.keywords,
    required this.pageFactory,
    this.valueBuilder,
  });

  bool matches(String normalizedQuery, AppSettings settings) {
    final valueText = valueBuilder?.call(settings) ?? '';
    final haystack = <String>[
      title,
      description,
      section,
      valueText,
      ...keywords,
    ].join(' ');

    return _normalizeSearchText(haystack).contains(normalizedQuery);
  }

  String buildSubtitle(AppSettings settings) {
    final valueText = valueBuilder?.call(settings);
    if (valueText == null || valueText.isEmpty) {
      return '$section · $description';
    }

    return '$section · $description\n当前：$valueText';
  }
}

List<SettingsMenuEntry> buildSettingsMenuEntries() {
  return <SettingsMenuEntry>[
    SettingsMenuEntry(
      icon: Icons.palette_outlined,
      title: '外观设置',
      subtitle: '主题、主色、页面切换动画',
      pageFactory: () => const ThemeSettingsPage(),
    ),
    SettingsMenuEntry(
      icon: Icons.play_circle_outline_rounded,
      title: '播放器设置',
      subtitle: '手势、倍速、自动播放',
      pageFactory: () => const PlayerSettingsPage(),
    ),
    SettingsMenuEntry(
      icon: Icons.cached_rounded,
      title: '缓存设置',
      subtitle: '缩略图缓存与播放进度清理',
      pageFactory: () => const CacheSettingsPage(),
    ),
    SettingsMenuEntry(
      icon: Icons.backup_table_outlined,
      title: '数据备份',
      subtitle: '本地备份、恢复与记录管理',
      pageFactory: () => const DataBackupPage(),
    ),
    SettingsMenuEntry(
      icon: Icons.info_outline_rounded,
      title: '关于',
      subtitle: '版本信息、开源协议',
      pageFactory: () => const AboutSettingsPage(),
    ),
  ];
}

List<SettingsSearchEntry> buildSettingsSearchEntries() {
  return <SettingsSearchEntry>[
    SettingsSearchEntry(
      title: '显示模式',
      description: '跟随系统、浅色、深色',
      section: '外观设置',
      keywords: const <String>['主题', '深色', '浅色', '夜间模式', '亮色'],
      pageFactory: () => const ThemeSettingsPage(),
      valueBuilder: (AppSettings settings) => settings.themeMode.label,
    ),
    SettingsSearchEntry(
      title: '应用主色',
      description: '调整底部导航与全局强调色',
      section: '外观设置',
      keywords: const <String>['主题色', '强调色', 'seed', '颜色'],
      pageFactory: () => const ThemeSettingsPage(),
      valueBuilder: (AppSettings settings) => _toHex(settings.seedColor),
    ),
    SettingsSearchEntry(
      title: '页面切换动画',
      description: '设置页面跳转时的过渡效果',
      section: '外观设置',
      keywords: const <String>['动画', '转场', '切页', '过渡'],
      pageFactory: () => const TransitionSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return settings.pageTransitionType.label;
      },
    ),
    SettingsSearchEntry(
      title: '默认倍速',
      description: '播放器打开时默认使用的播放速度',
      section: '播放器设置',
      keywords: const <String>['倍速', '速度', '播放速度'],
      pageFactory: () => const PlayerSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return '${settings.defaultPlaybackSpeed}x';
      },
    ),
    SettingsSearchEntry(
      title: '自动播放',
      description: '进入视频详情或切换视频时自动开始播放',
      section: '播放器设置',
      keywords: const <String>['自动', 'autoplay', '播放'],
      pageFactory: () => const PlayerSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return settings.autoPlayOnEnter ? '已开启' : '已关闭';
      },
    ),
    SettingsSearchEntry(
      title: '退出后恢复进度',
      description: '再次打开同一视频时从上次位置继续',
      section: '播放器设置',
      keywords: const <String>['续播', '记忆进度', '播放进度'],
      pageFactory: () => const PlayerSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return settings.rememberPlaybackPosition ? '已开启' : '已关闭';
      },
    ),
    SettingsSearchEntry(
      title: '默认播放模式',
      description: '列表循环、单集循环或播完停止',
      section: '播放器设置',
      keywords: const <String>['循环', '播放模式', '单集循环'],
      pageFactory: () => const PlayerSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return settings.defaultPlaybackMode.label;
      },
    ),
    SettingsSearchEntry(
      title: '默认画面比例',
      description: '自动、拉伸、原始或裁剪显示',
      section: '播放器设置',
      keywords: const <String>['比例', '画幅', '裁剪', 'fit'],
      pageFactory: () => const PlayerSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return settings.defaultAspectRatio.label;
      },
    ),
    SettingsSearchEntry(
      title: '长按倍速',
      description: '长按播放器时临时加速播放',
      section: '播放器设置',
      keywords: const <String>['长按', '加速', '快进', '手势'],
      pageFactory: () => const PlayerSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return '${settings.longPressPlaybackSpeed}x';
      },
    ),
    SettingsSearchEntry(
      title: '使用相对时长拖动',
      description: '根据滑动距离相对屏幕宽度的比例调整进度',
      section: '播放器设置',
      keywords: const <String>['拖动', '滑动', '进度', '手势'],
      pageFactory: () => const PlayerSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return settings.gestureSeekUsesVideoDuration ? '已开启' : '已关闭';
      },
    ),
    SettingsSearchEntry(
      title: '全屏滑动对应时长',
      description: '固定快进快退的滑动时长范围',
      section: '播放器设置',
      keywords: const <String>['滑动时长', '快进', '快退', '秒数'],
      pageFactory: () => const PlayerSettingsPage(),
      valueBuilder: (AppSettings settings) {
        return '${settings.gestureSeekSecondsPerSwipe} 秒';
      },
    ),
    SettingsSearchEntry(
      title: '清理缓存',
      description: '清除缩略图缓存和播放进度记录',
      section: '缓存设置',
      keywords: const <String>['缓存', '清除', '删除'],
      pageFactory: () => const CacheSettingsPage(),
    ),
    SettingsSearchEntry(
      title: '创建本地备份',
      description: '导出设置项、账户和列表数据快照',
      section: '数据备份',
      keywords: const <String>['备份', '导出', '保存'],
      pageFactory: () => const DataBackupPage(),
    ),
    SettingsSearchEntry(
      title: '从备份文件恢复',
      description: '从已有备份文件恢复本地配置',
      section: '数据备份',
      keywords: const <String>['恢复', '导入', '回滚'],
      pageFactory: () => const DataBackupPage(),
    ),
    SettingsSearchEntry(
      title: '版本信息',
      description: '查看当前应用版本和构建信息',
      section: '关于',
      keywords: const <String>['版本', 'app 版本', 'build'],
      pageFactory: () => const AboutSettingsPage(),
    ),
    SettingsSearchEntry(
      title: '开源许可证',
      description: '查看应用使用的第三方开源协议',
      section: '关于',
      keywords: const <String>['许可证', 'license', '协议', '开源'],
      pageFactory: () => const AboutSettingsPage(),
    ),
  ];
}

String normalizeSettingsSearchQuery(String query) {
  return _normalizeSearchText(query);
}

String _normalizeSearchText(String value) {
  return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
}

String _toHex(Color color) {
  final red = color.r.round().toRadixString(16).padLeft(2, '0');
  final green = color.g.round().toRadixString(16).padLeft(2, '0');
  final blue = color.b.round().toRadixString(16).padLeft(2, '0');
  return '#$red$green$blue'.toUpperCase();
}
