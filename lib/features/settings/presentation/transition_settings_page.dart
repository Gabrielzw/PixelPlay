import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/page_transition_type.dart';
import '../domain/settings_controller.dart';

class TransitionSettingsPage extends GetView<SettingsController> {
  const TransitionSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = controller.settings.value.pageTransitionType;

      return Scaffold(
        appBar: AppBar(title: const Text('页面切换动画')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '选择页面过渡动画',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '新的页面切换会按这里选中的动画执行。',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    RadioGroup<PageTransitionType>(
                      groupValue: selectedType,
                      onChanged: (PageTransitionType? nextType) async {
                        if (nextType == null) {
                          return;
                        }

                        await controller.setPageTransitionType(nextType);
                      },
                      child: Column(
                        children: PageTransitionType.values
                            .map(
                              (PageTransitionType type) =>
                                  RadioListTile<PageTransitionType>(
                                    value: type,
                                    title: Text(type.label),
                                    subtitle: Text(type.description),
                                  ),
                            )
                            .toList(growable: false),
                      ),
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
}
