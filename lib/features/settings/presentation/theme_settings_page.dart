import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/page_navigation.dart';
import '../../../shared/widgets/settings/settings_choice_sheet.dart';
import '../../../shared/widgets/settings/settings_shell.dart';
import '../domain/app_settings.dart';
import '../domain/page_transition_type.dart';
import '../domain/settings_controller.dart';
import 'transition_settings_page.dart';
import 'widgets/theme_color_picker_sheet.dart';

const List<Color> kThemePresetColors = <Color>[
  Color(0xFFE7A2BA),
  Color(0xFF8B5CF6),
  Color(0xFF3B82F6),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
];

class ThemeSettingsPage extends GetView<SettingsController> {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = controller.settings.value;

      return SettingsDetailScaffold(
        title: '外观设置',
        child: ListView(
          padding: kSettingsPagePadding,
          children: <Widget>[
            const SettingsSectionTitle('界面外观'),
            SettingsListItem(
              title: '显示模式',
              subtitle: settings.themeMode.label,
              onTap: () => _selectThemeMode(context, settings.themeMode),
            ),
            SettingsListItem(
              title: '应用主色',
              subtitle: '${_toHex(settings.seedColor)} · 底部导航与全局强调色',
              trailing: _ThemeColorTrailing(color: settings.seedColor),
              onTap: () => _selectThemeColor(context, settings.seedColor),
            ),
            SettingsListItem(
              title: '页面切换动画',
              subtitle: settings.pageTransitionType.label,
              onTap: () => pushRootPage<void>(
                context,
                (_) => const TransitionSettingsPage(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _selectThemeMode(
    BuildContext context,
    ThemeMode selectedThemeMode,
  ) async {
    final next = await showSettingsChoiceSheet<ThemeMode>(
      context: context,
      title: '显示模式',
      description: '选择应用界面的整体明暗风格。',
      selectedValue: selectedThemeMode,
      options: const <SettingsChoiceOption<ThemeMode>>[
        SettingsChoiceOption<ThemeMode>(
          value: ThemeMode.system,
          title: '跟随系统',
          icon: Icons.brightness_auto_outlined,
        ),
        SettingsChoiceOption<ThemeMode>(
          value: ThemeMode.light,
          title: '浅色',
          icon: Icons.light_mode_outlined,
        ),
        SettingsChoiceOption<ThemeMode>(
          value: ThemeMode.dark,
          title: '深色',
          icon: Icons.dark_mode_outlined,
        ),
      ],
    );

    if (next == null) {
      return;
    }

    await controller.setThemeMode(next);
  }

  Future<void> _selectThemeColor(
    BuildContext context,
    Color currentColor,
  ) async {
    final selectedColor = await showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ThemeColorPickerSheet(
          initialColor: currentColor,
          presetColors: kThemePresetColors,
        );
      },
    );

    if (selectedColor == null) {
      return;
    }

    await controller.setSeedColor(selectedColor);
  }

  String _toHex(Color color) {
    final red = color.r.round().toRadixString(16).padLeft(2, '0');
    final green = color.g.round().toRadixString(16).padLeft(2, '0');
    final blue = color.b.round().toRadixString(16).padLeft(2, '0');
    return '#$red$green$blue'.toUpperCase();
  }
}

class _ThemeColorTrailing extends StatelessWidget {
  final Color color;

  const _ThemeColorTrailing({required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right_rounded,
          size: 24,
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}
