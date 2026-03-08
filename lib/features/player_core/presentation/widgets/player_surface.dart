import 'package:flutter/material.dart';

import '../../../settings/domain/app_settings.dart';
import '../../domain/player_playback_port.dart';
import 'player_ui_constants.dart';

class PlayerSurface extends StatelessWidget {
  final PlayerPlaybackPort playbackPort;
  final PlayerAspectRatio aspectRatioMode;
  final Matrix4 transformMatrix;
  final bool flipHorizontal;
  final bool flipVertical;

  const PlayerSurface({
    super.key,
    required this.playbackPort,
    required this.aspectRatioMode,
    required this.transformMatrix,
    required this.flipHorizontal,
    required this.flipVertical,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kPlayerBackground,
      child: Transform(
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
