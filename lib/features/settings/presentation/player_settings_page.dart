import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import '../domain/app_settings.dart';
import '../domain/settings_controller.dart';

class PlayerSettingsPage extends GetView<SettingsController> {
  const PlayerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = controller.settings.value;

      return Scaffold(
        appBar: AppBar(title: const Text('播放器设置')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const UiSkeletonNotice(message: '这里的配置会作为播放器页面的默认值，并影响手势和播放行为。'),
            const SizedBox(height: 12),
            _DropdownTile<double>(
              title: '默认倍速',
              value: settings.defaultPlaybackSpeed,
              items: kPlaybackSpeedOptions,
              labelBuilder: (double speed) => '${speed}x',
              onChanged: controller.setDefaultPlaybackSpeed,
            ),
            const SizedBox(height: 12),
            _ChoiceTile<PlayerPlaybackMode>(
              title: '默认播放方式',
              options: PlayerPlaybackMode.values,
              selected: settings.defaultPlaybackMode,
              labelBuilder: (PlayerPlaybackMode mode) => mode.label,
              iconBuilder: (PlayerPlaybackMode mode) => mode.icon,
              onSelected: controller.setDefaultPlaybackMode,
            ),
            const SizedBox(height: 12),
            _ChoiceTile<PlayerAspectRatio>(
              title: '默认画面比例',
              options: PlayerAspectRatio.values,
              selected: settings.defaultAspectRatio,
              labelBuilder: (PlayerAspectRatio ratio) => ratio.label,
              iconBuilder: (PlayerAspectRatio ratio) => ratio.icon,
              onSelected: controller.setDefaultAspectRatio,
            ),
            const SizedBox(height: 12),
            _ChoiceTile<double>(
              title: '长按倍速',
              options: kLongPressSpeedOptions,
              selected: settings.longPressPlaybackSpeed,
              labelBuilder: (double speed) => '${speed}x',
              iconBuilder: (_) => Icons.speed_rounded,
              onSelected: controller.setLongPressPlaybackSpeed,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    value: settings.gestureSeekUsesVideoDuration,
                    onChanged: controller.setGestureSeekUsesVideoDuration,
                    title: const Text('按视频总时长拖动'),
                    subtitle: const Text('开启后，滑动距离会按视频总时长比例换算'),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '整屏滑动对应时长：${settings.gestureSeekSecondsPerSwipe}s',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '关闭“按视频总时长拖动”后，横向滑动会按这个固定时长快进快退。',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Slider(
                          value: settings.gestureSeekSecondsPerSwipe.toDouble(),
                          min: kGestureSeekMinSeconds.toDouble(),
                          max: kGestureSeekMaxSeconds.toDouble(),
                          divisions: kGestureSeekDivisions,
                          label: '${settings.gestureSeekSecondsPerSwipe}s',
                          onChanged: (double next) {
                            controller.setGestureSeekSecondsPerSwipe(
                              next.round(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    value: settings.rememberPlaybackPosition,
                    onChanged: controller.setRememberPlaybackPosition,
                    title: const Text('记忆播放进度'),
                    subtitle: const Text('下次打开同一视频时继续播放'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: settings.autoPlayNext,
                    onChanged: controller.setAutoPlayNext,
                    title: const Text('自动连播'),
                    subtitle: const Text('播放完成后自动跳到下一集'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DropdownTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<T> items;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;

  const _DropdownTile({
    required this.title,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<T>(
          key: ValueKey<T>(value),
          initialValue: value,
          decoration: InputDecoration(
            labelText: title,
            border: const OutlineInputBorder(),
          ),
          items: items
              .map(
                (T item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(labelBuilder(item)),
                ),
              )
              .toList(growable: false),
          onChanged: (T? next) {
            if (next == null) {
              return;
            }
            onChanged(next);
          },
        ),
      ),
    );
  }
}

class _ChoiceTile<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selected;
  final String Function(T value) labelBuilder;
  final IconData Function(T value) iconBuilder;
  final ValueChanged<T> onSelected;

  const _ChoiceTile({
    required this.title,
    required this.options,
    required this.selected,
    required this.labelBuilder,
    required this.iconBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options
                  .map(
                    (T option) => ChoiceChip(
                      selected: option == selected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(iconBuilder(option), size: 16),
                          const SizedBox(width: 6),
                          Text(labelBuilder(option)),
                        ],
                      ),
                      onSelected: (_) => onSelected(option),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}
