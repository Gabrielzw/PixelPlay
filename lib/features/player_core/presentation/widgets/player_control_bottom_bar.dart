import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../../settings/domain/app_settings.dart';
import '../../domain/player_controller.dart';
import 'player_ui_constants.dart';

class PlayerControlBottomBar extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onShowEpisodes;

  const PlayerControlBottomBar({
    super.key,
    required this.controller,
    required this.onShowEpisodes,
  });

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

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
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
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: controller.progress.value,
                min: kPlayerMinProgress,
                max: kPlayerMaxProgress,
                onChangeStart: hasDuration
                    ? (_) => controller.beginSeekPreview()
                    : null,
                onChanged: hasDuration ? controller.previewSeekToRatio : null,
                onChangeEnd: hasDuration
                    ? (_) => controller.commitSeekPreview()
                    : null,
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  tooltip: controller.isPlaying.value ? '暂停' : '播放',
                  onPressed: controller.togglePlay,
                  icon: Icon(
                    controller.isPlaying.value
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 28,
                  ),
                  color: Colors.white,
                ),
                IconButton(
                  tooltip: '下一集',
                  onPressed: controller.hasNext
                      ? () => controller.playNext()
                      : null,
                  icon: const Icon(Icons.skip_next_rounded, size: 28),
                  color: Colors.white,
                ),
                const Spacer(),
                _SpeedButton(controller: controller),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onShowEpisodes,
                  icon: const Icon(
                    Icons.playlist_play_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    '${controller.currentIndex.value + 1}/${controller.queue.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            color: applyOpacity(Colors.white, 0.12),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.speed_rounded, size: 18, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  '${controller.playbackSpeed.value}x',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
