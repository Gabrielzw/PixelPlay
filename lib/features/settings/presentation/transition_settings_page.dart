import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/settings/settings_choice_sheet.dart';
import '../../../shared/widgets/settings/settings_shell.dart';
import '../domain/page_transition_type.dart';
import '../domain/settings_controller.dart';

class TransitionSettingsPage extends GetView<SettingsController> {
  const TransitionSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = controller.settings.value.pageTransitionType;

      return SettingsDetailScaffold(
        title: '页面切换动画',
        child: ListView(
          padding: kSettingsPagePadding,
          children: <Widget>[
            const SettingsSectionTitle('切换效果'),
            SettingsListItem(
              title: '页面切换动画',
              subtitle: selectedType.label,
              onTap: () => _selectTransitionType(context, selectedType),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _selectTransitionType(
    BuildContext context,
    PageTransitionType selectedType,
  ) async {
    final next = await showSettingsChoiceSheet<PageTransitionType>(
      context: context,
      title: '页面切换动画',
      description: '新的页面跳转会按这里选中的动画执行。',
      selectedValue: selectedType,
      options: PageTransitionType.values
          .map((PageTransitionType type) {
            return SettingsChoiceOption<PageTransitionType>(
              value: type,
              title: type.label,
              subtitle: type.description,
            );
          })
          .toList(growable: false),
    );

    if (next == null) {
      return;
    }

    await controller.setPageTransitionType(next);
  }
}
