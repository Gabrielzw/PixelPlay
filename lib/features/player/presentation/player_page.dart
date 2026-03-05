import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';

const Color kPlayerBackground = Colors.black;
const double kPlayerInitialProgress = 0.12;
const double kPlayerMinProgress = 0;
const double kPlayerMaxProgress = 1;
const int kColorAlphaMax = 255;

const double kPlayerIconOpacity = 0.8;
const double kPlayerTopGradientStartOpacity = 0.72;
const double kPlayerBottomGradientEndOpacity = 0.82;
const double kPlayerLockedHintOpacity = 0.55;

Color _applyOpacity(Color color, double opacity) {
  return color.withAlpha((opacity * kColorAlphaMax).round());
}

class PlayerPage extends StatefulWidget {
  final String title;

  const PlayerPage({super.key, required this.title});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _isPlaying = true;
  bool _controlsLocked = false;
  double _progress = kPlayerInitialProgress;

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
  }

  void _toggleLock() {
    setState(() => _controlsLocked = !_controlsLocked);
  }

  void _seekTo(double value) {
    setState(() => _progress = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPlayerBackground,
      body: SafeArea(
        child: _PlayerLayout(
          title: widget.title,
          isPlaying: _isPlaying,
          controlsLocked: _controlsLocked,
          progress: _progress,
          onBack: () => Navigator.of(context).pop(),
          onTogglePlay: _togglePlay,
          onToggleLock: _toggleLock,
          onSeek: _seekTo,
        ),
      ),
    );
  }
}

class _PlayerLayout extends StatelessWidget {
  final String title;
  final bool isPlaying;
  final bool controlsLocked;
  final double progress;
  final VoidCallback onBack;
  final VoidCallback onTogglePlay;
  final VoidCallback onToggleLock;
  final ValueChanged<double> onSeek;

  const _PlayerLayout({
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
        const Positioned.fill(child: _VideoSurfacePlaceholder()),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(
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
          child: _BottomControls(
            enabled: !controlsLocked,
            isPlaying: isPlaying,
            progress: progress,
            onTogglePlay: onTogglePlay,
            onSeek: onSeek,
          ),
        ),
        if (controlsLocked) const Positioned.fill(child: _LockedHint()),
      ],
    );
  }
}

class _VideoSurfacePlaceholder extends StatelessWidget {
  const _VideoSurfacePlaceholder();

  @override
  Widget build(BuildContext context) {
    final tint = Theme.of(context).colorScheme.primary;

    return ColoredBox(
      color: kPlayerBackground,
      child: Center(
        child: Icon(
          Icons.ondemand_video,
          size: 84,
          color: _applyOpacity(tint, kPlayerIconOpacity),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final bool controlsLocked;
  final VoidCallback onBack;
  final VoidCallback onToggleLock;

  const _TopBar({
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
            _applyOpacity(Colors.black, kPlayerTopGradientStartOpacity),
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
          IconButton(
            tooltip: '更多',
            onPressed: () => showNotImplementedSnackBar(context, '更多设置（未接入）'),
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  final bool enabled;
  final bool isPlaying;
  final double progress;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onSeek;

  const _BottomControls({
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
                _applyOpacity(Colors.black, kPlayerBottomGradientEndOpacity),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _ProgressBar(progress: progress, onSeek: onSeek),
              const SizedBox(height: 8),
              _ControlRow(isPlaying: isPlaying, onTogglePlay: onTogglePlay),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onSeek;

  const _ProgressBar({required this.progress, required this.onSeek});

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

class _ControlRow extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTogglePlay;

  const _ControlRow({required this.isPlaying, required this.onTogglePlay});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          tooltip: '倍速',
          onPressed: () => showNotImplementedSnackBar(context, '倍速（未接入）'),
          icon: const Icon(Icons.speed),
          color: Colors.white,
        ),
        IconButton(
          tooltip: '画面比例',
          onPressed: () => showNotImplementedSnackBar(context, '画面比例（未接入）'),
          icon: const Icon(Icons.aspect_ratio),
          color: Colors.white,
        ),
        IconButton(
          tooltip: '快退',
          onPressed: () => showNotImplementedSnackBar(context, '快退（未接入）'),
          icon: const Icon(Icons.replay_10),
          color: Colors.white,
        ),
        const Spacer(),
        FilledButton.tonal(
          onPressed: onTogglePlay,
          style: FilledButton.styleFrom(
            minimumSize: const Size(56, 56),
            shape: const CircleBorder(),
          ),
          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
        ),
        const Spacer(),
        IconButton(
          tooltip: '快进',
          onPressed: () => showNotImplementedSnackBar(context, '快进（未接入）'),
          icon: const Icon(Icons.forward_10),
          color: Colors.white,
        ),
        IconButton(
          tooltip: '画质增强(Anime4K)',
          onPressed: () => showNotImplementedSnackBar(context, 'Anime4K（未接入）'),
          icon: const Icon(Icons.auto_fix_high),
          color: Colors.white,
        ),
        IconButton(
          tooltip: '截图',
          onPressed: () => showNotImplementedSnackBar(context, '截图（未接入）'),
          icon: const Icon(Icons.photo_camera_outlined),
          color: Colors.white,
        ),
      ],
    );
  }
}

class _LockedHint extends StatelessWidget {
  const _LockedHint();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _applyOpacity(Colors.black, kPlayerLockedHintOpacity),
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
