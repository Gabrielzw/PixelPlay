import 'package:flutter/material.dart';

import '../../../settings/domain/app_settings.dart';
import '../../domain/player_playback_port.dart';
import '../../domain/player_queue_item.dart';
import 'player_ui_constants.dart';

const double _kControlsMaskOpacity = 0.08;

class PlayerSurface extends StatelessWidget {
  final PlayerPlaybackPort playbackPort;
  final PlayerQueueItem item;
  final PlayerAspectRatio aspectRatioMode;
  final bool controlsVisible;

  const PlayerSurface({
    super.key,
    required this.playbackPort,
    required this.item,
    required this.aspectRatioMode,
    required this.controlsVisible,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kPlayerBackground,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          playbackPort.buildVideoView(fit: _resolveBoxFit(aspectRatioMode)),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: controlsVisible ? _kControlsMaskOpacity : 0,
              duration: kPlayerOverlayAnimationDuration,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black12,
                      Colors.transparent,
                      Colors.black26,
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (controlsVisible)
            Positioned(
              left: 28,
              bottom: 28,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _InfoChip(label: item.isRemote ? 'WebDAV' : '本地'),
                  _InfoChip(label: item.sourceLabel),
                  if (item.resolutionText != null)
                    _InfoChip(label: item.resolutionText!),
                ],
              ),
            ),
        ],
      ),
    );
  }

  BoxFit _resolveBoxFit(PlayerAspectRatio value) {
    return switch (value) {
      PlayerAspectRatio.fit => BoxFit.contain,
      PlayerAspectRatio.fill => BoxFit.fill,
      PlayerAspectRatio.original => BoxFit.none,
      PlayerAspectRatio.crop => BoxFit.cover,
    };
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: applyOpacity(Colors.black, 0.36),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
