import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import 'player_control_actions.dart';
import 'player_control_bottom_bar.dart';
import 'player_ui_constants.dart';

class PlayerControlsOverlay extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onBack;
  final VoidCallback onOpenSettings;

  const PlayerControlsOverlay({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.controlsLocked.value) {
        return PlayerLockedOverlay(onUnlock: controller.toggleLock);
      }

      final visible = controller.controlsVisible.value;
      return Stack(
        children: <Widget>[
          SafeArea(
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: kPlayerOverlayAnimationDuration,
              child: IgnorePointer(
                ignoring: !visible,
                child: Column(
                  children: <Widget>[
                    PlayerControlActions(
                      controller: controller,
                      onBack: onBack,
                      onOpenSettings: onOpenSettings,
                    ),
                    const Spacer(),
                    PlayerControlBottomBar(controller: controller),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: kPlayerOverlayAnimationDuration,
              child: IgnorePointer(
                ignoring: !visible,
                child: Center(
                  child: PlayerSideLockButton(
                    isLocked: false,
                    onPressed: controller.toggleLock,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: kPlayerOverlayAnimationDuration,
              child: IgnorePointer(
                ignoring: !visible,
                child: PlayerPlayPauseButton(controller: controller),
              ),
            ),
          ),
        ],
      );
    });
  }
}
