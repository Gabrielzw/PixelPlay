import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../../settings/domain/app_settings.dart';
import '../../domain/player_controller.dart';

const double _kBottomBarMargin = 12;
const double _kBottomBarPaddingTop = 8;
const double _kBottomBarSpacing = 8;
const double _kSpeedButtonHorizontalPadding = 8;
const double _kSpeedButtonVerticalPadding = 10;
const double _kSpeedMenuRadius = 12;
const double _kSpeedMenuCheckWidth = 24;
const double _kSpeedMenuItemHeight = 40;
const double _kSpeedMenuMaxHeight = 280;
const Color _kSpeedMenuBackgroundColor = Color(0xFF111111);

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
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(
          _kBottomBarMargin,
          0,
          _kBottomBarMargin,
          _kBottomBarMargin,
        ),
        padding: const EdgeInsets.fromLTRB(
          _kBottomBarMargin,
          _kBottomBarPaddingTop,
          _kBottomBarMargin,
          _kBottomBarMargin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTimeRow(context, hasDuration),
            _buildProgressBar(colorScheme, hasDuration),
            _buildActionRow(context),
          ],
        ),
      );
    });
  }

  Widget _buildTimeRow(BuildContext context, bool hasDuration) {
    final textTheme = Theme.of(context).textTheme;
    final currentText = hasDuration
        ? formatVideoDuration(controller.position.value)
        : '--:--';
    final totalText = hasDuration
        ? formatVideoDuration(controller.duration.value)
        : '--:--';
    final textStyle = textTheme.bodySmall?.copyWith(color: Colors.white70);
    return Row(
      children: <Widget>[
        Text(currentText, style: textStyle),
        const Spacer(),
        Text(totalText, style: textStyle),
      ],
    );
  }

  Widget _buildProgressBar(ColorScheme colorScheme, bool hasDuration) {
    return ProgressBar(
      progress: hasDuration ? controller.position.value : Duration.zero,
      buffered: _resolveBufferedDuration(hasDuration),
      total: hasDuration ? controller.duration.value : Duration.zero,
      timeLabelLocation: TimeLabelLocation.none,
      barHeight: 3,
      thumbRadius: 6,
      thumbGlowRadius: 14,
      baseBarColor: Colors.white24,
      bufferedBarColor: Colors.white38,
      progressBarColor: colorScheme.primary,
      thumbColor: colorScheme.primary,
      onDragStart: hasDuration ? (_) => controller.beginSeekPreview() : null,
      onDragUpdate: hasDuration
          ? (ThumbDragDetails details) =>
                controller.previewSeekPosition(details.timeStamp)
          : null,
      onSeek: hasDuration ? controller.seekToPosition : null,
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Row(
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
          onPressed: controller.hasNext ? () => controller.playNext() : null,
          icon: const Icon(Icons.skip_next_rounded, size: 28),
          color: Colors.white,
        ),
        const Spacer(),
        _SpeedButton(controller: controller),
        const SizedBox(width: _kBottomBarSpacing),
        IconButton(
          tooltip: '播放列表',
          onPressed: onShowEpisodes,
          icon: const Icon(
            Icons.playlist_play_rounded,
            size: 24,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Duration? _resolveBufferedDuration(bool hasDuration) {
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
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(() {
      final selectedSpeed = controller.playbackSpeed.value;
      return PopupMenuButton<double>(
        tooltip: '倍速',
        padding: EdgeInsets.zero,
        color: _kSpeedMenuBackgroundColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kSpeedMenuRadius),
        ),
        constraints: const BoxConstraints(maxHeight: _kSpeedMenuMaxHeight),
        onSelected: controller.setPlaybackSpeed,
        popUpAnimationStyle: AnimationStyle.noAnimation,
        itemBuilder: (BuildContext context) {
          return kPlaybackSpeedOptions
              .map(
                (double speed) => _buildSpeedMenuItem(
                  colorScheme: colorScheme,
                  selectedSpeed: selectedSpeed,
                  speed: speed,
                ),
              )
              .toList(growable: false);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _kSpeedButtonHorizontalPadding,
            vertical: _kSpeedButtonVerticalPadding,
          ),
          child: Text(
            _speedButtonLabel(selectedSpeed),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  PopupMenuItem<double> _buildSpeedMenuItem({
    required ColorScheme colorScheme,
    required double selectedSpeed,
    required double speed,
  }) {
    final isSelected = speed == selectedSpeed;
    return PopupMenuItem<double>(
      value: speed,
      height: _kSpeedMenuItemHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: _kSpeedMenuCheckWidth,
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  )
                : null,
          ),
          Text(
            '${speed}x',
            style: TextStyle(
              color: isSelected ? colorScheme.primary : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _speedButtonLabel(double speed) {
    if (speed == kDefaultPlaybackSpeed) {
      return '倍速';
    }
    return '${speed}x';
  }
}
