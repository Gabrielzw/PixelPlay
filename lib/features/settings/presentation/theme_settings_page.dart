import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/settings_controller.dart';
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

      return Scaffold(
        appBar: AppBar(title: const Text('主题与主色')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '显示模式',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 14),
                    SegmentedButton<ThemeMode>(
                      segments: const <ButtonSegment<ThemeMode>>[
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto_outlined),
                          label: Text('跟随系统'),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined),
                          label: Text('浅色'),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined),
                          label: Text('深色'),
                        ),
                      ],
                      selected: <ThemeMode>{settings.themeMode},
                      showSelectedIcon: false,
                      onSelectionChanged: (Set<ThemeMode> selection) async {
                        if (selection.isEmpty) return;
                        await controller.setThemeMode(selection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '应用主色',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '底部 Tab 选中态和全局强调色会跟随这里变化。',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: kThemePresetColors
                          .map((Color color) {
                            return _ThemeColorOption(
                              color: color,
                              isSelected: settings.seedColor == color,
                              onTap: () => controller.setSeedColor(color),
                            );
                          })
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: settings.seedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: const Text('自定义颜色'),
                      subtitle: Text(_toHex(settings.seedColor)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _pickCustomColor(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _pickCustomColor(BuildContext context) async {
    final currentColor = controller.settings.value.seedColor;
    final selectedColor = await showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ThemeColorPickerSheet(initialColor: currentColor),
    );

    if (selectedColor == null) return;
    await controller.setSeedColor(selectedColor);
  }

  String _toHex(Color color) {
    final red = color.r.round().toRadixString(16).padLeft(2, '0');
    final green = color.g.round().toRadixString(16).padLeft(2, '0');
    final blue = color.b.round().toRadixString(16).padLeft(2, '0');
    return '#$red$green$blue'.toUpperCase();
  }
}

class _ThemeColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.onSurface
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: Colors.white)
            : null,
      ),
    );
  }
}
