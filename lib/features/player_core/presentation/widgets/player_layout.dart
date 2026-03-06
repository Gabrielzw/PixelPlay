import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import 'player_controls.dart';
import 'player_feedback.dart';
import 'player_gesture_layer.dart';
import 'player_surface.dart';

class PlayerLayout extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onBack;
  final VoidCallback onOpenSettings;

  const PlayerLayout({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Obx(
            () => PlayerSurface(
              item: controller.currentItem.value,
              aspectRatioMode: controller.aspectRatio.value,
              controlsVisible: controller.controlsVisible.value,
            ),
          ),
        ),
        Positioned.fill(child: PlayerGestureLayer(controller: controller)),
        Positioned.fill(
          child: PlayerControlsOverlay(
            controller: controller,
            onBack: onBack,
            onOpenSettings: onOpenSettings,
          ),
        ),
        Positioned.fill(
          child: PlayerFeedbackLayer(controller: controller, onBack: onBack),
        ),
      ],
    );
  }
}
