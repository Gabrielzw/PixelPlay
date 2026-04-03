import 'package:flutter/material.dart';

import '../../../app/router/page_navigation.dart';
import '../../../shared/widgets/settings/settings_shell.dart';

const String kPixelPlayDisplayVersion = '1.0.0+1';

class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsDetailScaffold(
      title: '关于',
      child: ListView(
        padding: kSettingsPagePadding,
        children: <Widget>[
          const SettingsSectionTitle('应用信息'),
          SettingsListItem(
            title: '版本信息',
            subtitle: 'PixelPlay $kPixelPlayDisplayVersion',
            onTap: () => _showAboutDialog(context),
          ),
          SettingsListItem(
            title: '开源许可证',
            subtitle: '查看应用使用的开源许可信息',
            onTap: () => pushRootPage<void>(
              context,
              (_) => const LicensePage(applicationName: 'PixelPlay'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'PixelPlay',
      applicationVersion: kPixelPlayDisplayVersion,
      applicationIcon: const _AboutIcon(),
      children: const <Widget>[Text('本地视频播放器与媒体管理工具。')],
    );
  }
}

class _AboutIcon extends StatelessWidget {
  const _AboutIcon();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.play_circle_fill_rounded,
        size: 32,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }
}
