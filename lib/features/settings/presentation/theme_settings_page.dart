import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import '../domain/settings_controller.dart';

class ThemeSettingsPage extends GetView<SettingsController> {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeMode = controller.settings.value.themeMode;

      return Scaffold(
        appBar: AppBar(title: const Text('主题')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const UiSkeletonNotice(message: 'UI 骨架阶段：主题选择未持久化。'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SegmentedButton<ThemeMode>(
                  segments: const <ButtonSegment<ThemeMode>>[
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto),
                      label: Text('跟随系统'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('亮色'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('暗色'),
                    ),
                  ],
                  selected: <ThemeMode>{themeMode},
                  showSelectedIcon: false,
                  onSelectionChanged: (selection) {
                    if (selection.isEmpty) return;
                    controller.setThemeMode(selection.first);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
