import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import '../../domain/player_playback_port.dart';
import 'player_controls.dart';
import 'player_feedback.dart';
import 'player_gesture_layer.dart';
import 'player_surface.dart';

class PlayerLayout extends StatelessWidget {
  final PlayerController controller;
  final PlayerPlaybackPort playbackPort;
  final VoidCallback onBack;
  final VoidCallback onOpenSettings;
  final VoidCallback onSurfaceTap;
  final VoidCallback onToggleLock;
  final VoidCallback onShowEpisodePanel;
  final VoidCallback onShowMorePanel;
  final VoidCallback onClosePanels;
  final VoidCallback onToggleHorizontalFlip;
  final VoidCallback onToggleVerticalFlip;
  final bool showEpisodePanel;
  final bool showMorePanel;
  final bool flipHorizontal;
  final bool flipVertical;

  const PlayerLayout({
    super.key,
    required this.controller,
    required this.playbackPort,
    required this.onBack,
    required this.onOpenSettings,
    required this.onSurfaceTap,
    required this.onToggleLock,
    required this.onShowEpisodePanel,
    required this.onShowMorePanel,
    required this.onClosePanels,
    required this.onToggleHorizontalFlip,
    required this.onToggleVerticalFlip,
    required this.showEpisodePanel,
    required this.showMorePanel,
    required this.flipHorizontal,
    required this.flipVertical,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Obx(
            () => PlayerSurface(
              playbackPort: playbackPort,
              aspectRatioMode: controller.aspectRatio.value,
              controlsVisible: controller.controlsVisible.value,
              brightnessLevel: controller.brightnessLevel.value,
              flipHorizontal: flipHorizontal,
              flipVertical: flipVertical,
            ),
          ),
        ),
        Positioned.fill(
          child: PlayerGestureLayer(
            controller: controller,
            onTap: onSurfaceTap,
            interactionsEnabled: !showEpisodePanel && !showMorePanel,
          ),
        ),
        Positioned.fill(
          child: PlayerControlsOverlay(
            controller: controller,
            onBack: onBack,
            onOpenSettings: onOpenSettings,
            onToggleLock: onToggleLock,
            onShowEpisodePanel: onShowEpisodePanel,
            onShowMorePanel: onShowMorePanel,
            onClosePanels: onClosePanels,
            onToggleHorizontalFlip: onToggleHorizontalFlip,
            onToggleVerticalFlip: onToggleVerticalFlip,
            showEpisodePanel: showEpisodePanel,
            showMorePanel: showMorePanel,
            flipHorizontal: flipHorizontal,
            flipVertical: flipVertical,
          ),
        ),
        Positioned.fill(
          child: PlayerFeedbackLayer(controller: controller, onBack: onBack),
        ),
      ],
    );
  }
}
