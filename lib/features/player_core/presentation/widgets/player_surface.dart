import 'package:flutter/material.dart';

import '../../../settings/domain/app_settings.dart';
import '../../domain/player_playback_port.dart';
import 'player_ui_constants.dart';

const double _kControlsMaskOpacity = 0.08;

class PlayerSurface extends StatelessWidget {
  final PlayerPlaybackPort playbackPort;
  final PlayerAspectRatio aspectRatioMode;
  final bool controlsVisible;
  final Matrix4 transformMatrix;
  final bool flipHorizontal;
  final bool flipVertical;

  const PlayerSurface({
    super.key,
    required this.playbackPort,
    required this.aspectRatioMode,
    required this.controlsVisible,
    required this.transformMatrix,
    required this.flipHorizontal,
    required this.flipVertical,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kPlayerBackground,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Transform(
            transform: transformMatrix,
            child: Center(
              child: Transform.flip(
                flipX: flipHorizontal,
                flipY: flipVertical,
                child: playbackPort.buildVideoView(
                  fit: _resolveBoxFit(aspectRatioMode),
                ),
              ),
            ),
          ),
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
