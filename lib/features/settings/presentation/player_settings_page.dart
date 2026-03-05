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
      final state = controller.settings.value;

      return Scaffold(
        appBar: AppBar(title: const Text('播放器默认设置')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const UiSkeletonNotice(message: 'UI 骨架阶段：设置未持久化，未与播放器联动。'),
            const SizedBox(height: 12),
            _PlaybackSpeedTile(
              value: state.defaultPlaybackSpeed,
              onChanged: controller.setDefaultPlaybackSpeed,
            ),
            const SizedBox(height: 12),
            _AspectRatioTile(
              value: state.defaultAspectRatio,
              onChanged: controller.setDefaultAspectRatio,
            ),
            const SizedBox(height: 12),
            _GestureSeekTile(
              valueSeconds: state.gestureSeekSecondsPerSwipe,
              onChanged: controller.setGestureSeekSecondsPerSwipe,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    value: state.rememberPlaybackPosition,
                    onChanged: controller.setRememberPlaybackPosition,
                    title: const Text('记忆播放进度'),
                    subtitle: const Text('下次打开无缝续播'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: state.autoPlayNext,
                    onChanged: controller.setAutoPlayNext,
                    title: const Text('自动播放下一个'),
                    subtitle: const Text('当前视频结束后自动连播'),
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

class _PlaybackSpeedTile extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _PlaybackSpeedTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<double>(
          key: ValueKey<double>(value),
          initialValue: value,
          decoration: const InputDecoration(
            labelText: '默认倍速',
            border: OutlineInputBorder(),
          ),
          items: kPlaybackSpeedOptions
              .map(
                (speed) => DropdownMenuItem<double>(
                  value: speed,
                  child: Text('${speed}x'),
                ),
              )
              .toList(growable: false),
          onChanged: (next) {
            if (next == null) return;
            onChanged(next);
          },
        ),
      ),
    );
  }
}

class _AspectRatioTile extends StatelessWidget {
  final PlayerAspectRatio value;
  final ValueChanged<PlayerAspectRatio> onChanged;

  const _AspectRatioTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<PlayerAspectRatio>(
          key: ValueKey<PlayerAspectRatio>(value),
          initialValue: value,
          decoration: const InputDecoration(
            labelText: '默认画面比例',
            border: OutlineInputBorder(),
          ),
          items: PlayerAspectRatio.values
              .map(
                (ratio) => DropdownMenuItem<PlayerAspectRatio>(
                  value: ratio,
                  child: Text(ratio.label),
                ),
              )
              .toList(growable: false),
          onChanged: (next) {
            if (next == null) return;
            onChanged(next);
          },
        ),
      ),
    );
  }
}

class _GestureSeekTile extends StatelessWidget {
  final int valueSeconds;
  final ValueChanged<int> onChanged;

  const _GestureSeekTile({required this.valueSeconds, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('手势快进灵敏度', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              '左右滑动一次对应 $valueSeconds 秒',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Slider(
              value: valueSeconds.toDouble(),
              min: kGestureSeekMinSeconds.toDouble(),
              max: kGestureSeekMaxSeconds.toDouble(),
              divisions: kGestureSeekDivisions,
              label: '${valueSeconds}s',
              onChanged: (next) => onChanged(next.round()),
            ),
          ],
        ),
      ),
    );
  }
}
