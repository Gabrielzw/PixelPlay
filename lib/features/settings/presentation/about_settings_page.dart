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
}
