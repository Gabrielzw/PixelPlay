import 'package:flutter/material.dart';

import 'player_controls.dart';
import 'player_ui_constants.dart';

class PlayerLayout extends StatelessWidget {
  final String title;
  final bool isPlaying;
  final bool controlsLocked;
  final double progress;
  final VoidCallback onBack;
  final VoidCallback onTogglePlay;
  final VoidCallback onToggleLock;
  final ValueChanged<double> onSeek;

  const PlayerLayout({
    super.key,
    required this.title,
    required this.isPlaying,
    required this.controlsLocked,
    required this.progress,
    required this.onBack,
    required this.onTogglePlay,
    required this.onToggleLock,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Positioned.fill(child: VideoSurfacePlaceholder()),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: PlayerTopBar(
            title: title,
            controlsLocked: controlsLocked,
            onBack: onBack,
            onToggleLock: onToggleLock,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: PlayerBottomControls(
            enabled: !controlsLocked,
            isPlaying: isPlaying,
            progress: progress,
            onTogglePlay: onTogglePlay,
            onSeek: onSeek,
          ),
        ),
        if (controlsLocked) const Positioned.fill(child: PlayerLockedHint()),
      ],
    );
  }
}

class VideoSurfacePlaceholder extends StatelessWidget {
  const VideoSurfacePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final tint = Theme.of(context).colorScheme.primary;

    return ColoredBox(
      color: kPlayerBackground,
      child: Center(
        child: Icon(
          Icons.ondemand_video,
          size: 84,
          color: applyOpacity(tint, kPlayerIconOpacity),
        ),
      ),
    );
  }
}

class PlayerLockedHint extends StatelessWidget {
  const PlayerLockedHint({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: applyOpacity(Colors.black, kPlayerLockedHintOpacity),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.lock, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  '已锁定（UI 骨架）',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

