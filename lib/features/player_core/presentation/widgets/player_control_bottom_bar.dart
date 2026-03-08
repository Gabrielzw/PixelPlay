import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
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
      final colorScheme = Theme.of(context).colorScheme;
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
            ProgressBar(
              progress: hasDuration ? controller.position.value : Duration.zero,
              buffered: _resolveBufferedDuration(controller, hasDuration),
              total: hasDuration ? controller.duration.value : Duration.zero,
              timeLabelLocation: TimeLabelLocation.none,
              barHeight: 3,
              thumbRadius: 6,
              thumbGlowRadius: 14,
              baseBarColor: Colors.white24,
              bufferedBarColor: Colors.white38,
              progressBarColor: colorScheme.primary,
              thumbColor: colorScheme.primary,
              onDragStart: hasDuration
                  ? (_) => controller.beginSeekPreview()
                  : null,
              onDragUpdate: hasDuration
                  ? (ThumbDragDetails details) =>
                        controller.previewSeekPosition(details.timeStamp)
                  : null,
              onSeek: hasDuration ? controller.seekToPosition : null,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  tooltip: controller.isPlaying.value ? '??' : '??',
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
                  tooltip: '???',
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

  Duration? _resolveBufferedDuration(
    PlayerController controller,
    bool hasDuration,
  ) {
    if (!hasDuration || !controller.currentItem.value.isRemote) {
      return null;
    }
    return controller.bufferedPosition.value;
  }
}

class _SpeedButton extends StatelessWidget {
  final PlayerController controller;

  const _SpeedButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopupMenuButton<double>(
        tooltip: '??',
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
