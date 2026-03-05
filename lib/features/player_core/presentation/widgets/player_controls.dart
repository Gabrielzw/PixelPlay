import 'package:flutter/material.dart';

import '../../../../shared/utils/not_implemented.dart';
import 'player_ui_constants.dart';

class PlayerTopBar extends StatelessWidget {
  final String title;
  final bool controlsLocked;
  final VoidCallback onBack;
  final VoidCallback onToggleLock;

  const PlayerTopBar({
    super.key,
    required this.title,
    required this.controlsLocked,
    required this.onBack,
    required this.onToggleLock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            applyOpacity(Colors.black, kPlayerTopGradientStartOpacity),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: '返回',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
          IconButton(
            tooltip: controlsLocked ? '解锁' : '锁定',
            onPressed: onToggleLock,
            icon: Icon(controlsLocked ? Icons.lock : Icons.lock_open),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class PlayerBottomControls extends StatelessWidget {
  final bool enabled;
  final bool isPlaying;
  final double progress;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onSeek;

  const PlayerBottomControls({
    super.key,
    required this.enabled,
    required this.isPlaying,
    required this.progress,
    required this.onTogglePlay,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.transparent,
                applyOpacity(Colors.black, kPlayerBottomGradientEndOpacity),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PlayerProgressBar(progress: progress, onSeek: onSeek),
              const SizedBox(height: 8),
              PlayerControlRow(
                isPlaying: isPlaying,
                onTogglePlay: onTogglePlay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerProgressBar extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onSeek;

  const PlayerProgressBar({
    super.key,
    required this.progress,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Slider(
          value: progress,
          min: kPlayerMinProgress,
          max: kPlayerMaxProgress,
          onChanged: onSeek,
        ),
        Row(
          children: <Widget>[
            Text(
              '--:--',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const Spacer(),
            Text(
              '--:--',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }
}

class PlayerControlRow extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTogglePlay;

  const PlayerControlRow({
    super.key,
    required this.isPlaying,
    required this.onTogglePlay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const _PlayerActionButton(
          tooltip: '倍速',
          icon: Icons.speed,
          message: '倍速（未接入）',
        ),
        const _PlayerActionButton(
          tooltip: '画面比例',
          icon: Icons.aspect_ratio,
          message: '画面比例（未接入）',
        ),
        const _PlayerActionButton(
          tooltip: '快退',
          icon: Icons.replay_10,
          message: '快退（未接入）',
        ),
        const Spacer(),
        _PlayerPlayToggleButton(
          isPlaying: isPlaying,
          onPressed: onTogglePlay,
        ),
        const Spacer(),
        const _PlayerActionButton(
          tooltip: '快进',
          icon: Icons.forward_10,
          message: '快进（未接入）',
        ),
        const _PlayerActionButton(
          tooltip: '画质增强(Anime4K)',
          icon: Icons.auto_fix_high,
          message: 'Anime4K（未接入）',
        ),
        const _PlayerActionButton(
          tooltip: '截图',
          icon: Icons.photo_camera_outlined,
          message: '截图（未接入）',
        ),
      ],
    );
  }
}

class _PlayerActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final String message;

  const _PlayerActionButton({
    required this.tooltip,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () => showNotImplementedSnackBar(context, message),
      icon: Icon(icon),
      color: Colors.white,
    );
  }
}

class _PlayerPlayToggleButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const _PlayerPlayToggleButton({
    required this.isPlaying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(56, 56),
        shape: const CircleBorder(),
      ),
      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
    );
  }
}
