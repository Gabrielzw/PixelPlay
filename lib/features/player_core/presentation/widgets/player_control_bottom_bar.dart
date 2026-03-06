import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../../settings/domain/app_settings.dart';
import '../../domain/player_controller.dart';
import 'player_ui_constants.dart';

class PlayerControlBottomBar extends StatelessWidget {
  final PlayerController controller;

  const PlayerControlBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.transparent,
              applyOpacity(Colors.black, kPlayerBottomGradientEndOpacity),
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _ProgressBar(controller: controller),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                IconButton(
                  tooltip: '上一首',
                  onPressed: controller.hasPrevious
                      ? () => controller.playPrevious()
                      : null,
                  icon: const Icon(Icons.skip_previous_rounded),
                  color: Colors.white,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${controller.currentIndex.value + 1}/${controller.queue.length}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '下一首',
                  onPressed: controller.hasNext
                      ? () => controller.playNext()
                      : null,
                  icon: const Icon(Icons.skip_next_rounded),
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                _SpeedButton(controller: controller),
                const SizedBox(width: 12),
                FilledButton.tonalIcon(
                  onPressed: controller.cycleAspectRatio,
                  icon: const Icon(Icons.aspect_ratio_rounded),
                  label: Text(controller.aspectRatio.value.label),
                ),
                const Spacer(),
                Text(
                  controller.currentItem.value.isRemote ? 'WebDAV' : '本地视频',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _ProgressBar extends StatelessWidget {
  final PlayerController controller;

  const _ProgressBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasDuration = controller.hasKnownDuration;
      final currentText = hasDuration
          ? formatVideoDuration(controller.position.value)
          : '--:--';
      final totalText = hasDuration
          ? formatVideoDuration(controller.duration.value)
          : '--:--';

      return Column(
        children: <Widget>[
          Slider(
            value: controller.progress.value,
            min: kPlayerMinProgress,
            max: kPlayerMaxProgress,
            onChanged: hasDuration ? controller.seekToRatio : null,
          ),
          Row(
            children: <Widget>[
              Text(
                currentText,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                totalText,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _SpeedButton extends StatelessWidget {
  final PlayerController controller;

  const _SpeedButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopupMenuButton<double>(
        tooltip: '倍速',
        onSelected: controller.setPlaybackSpeed,
        itemBuilder: (BuildContext context) {
          return kPlaybackSpeedOptions
              .map(
                (double speed) => PopupMenuItem<double>(
                  value: speed,
                  child: Text('${speed}x'),
                ),
              )
              .toList(growable: false);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.speed_rounded, size: 18),
                const SizedBox(width: 6),
                Text('${controller.playbackSpeed.value}x'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
