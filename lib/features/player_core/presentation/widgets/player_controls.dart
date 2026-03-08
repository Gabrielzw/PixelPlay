import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import 'player_control_actions.dart';
import 'player_control_bottom_bar.dart';
import 'player_episode_panel.dart';
import 'player_more_panel.dart';
import 'player_ui_constants.dart';

class PlayerControlsOverlay extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onBack;
  final VoidCallback onOpenSettings;
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

  const PlayerControlsOverlay({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onOpenSettings,
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

  static const double _kControlsScrimOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.controlsLocked.value) {
        return PlayerLockedOverlay(onUnlock: onToggleLock);
      }

      final visible = controller.controlsVisible.value;
      final isCapturingScreenshot = controller.isCapturingScreenshot.value;
      final panelsOpen = showEpisodePanel || showMorePanel;

      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: visible || panelsOpen ? 1 : 0,
              duration: kPlayerOverlayAnimationDuration,
              child: IgnorePointer(
                child: ColoredBox(
                  color: applyOpacity(Colors.black, _kControlsScrimOpacity),
                ),
              ),
            ),
          ),
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
                      onShowMore: onShowMorePanel,
                    ),
                    const Spacer(),
                    PlayerControlBottomBar(
                      controller: controller,
                      onShowEpisodes: onShowEpisodePanel,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: _PlayerSideActionsOverlay(
              visible: visible,
              isCapturingScreenshot: isCapturingScreenshot,
              onScreenshot: controller.captureScreenshot,
              onToggleLock: onToggleLock,
            ),
          ),
          if (panelsOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClosePanels,
                child: const SizedBox.expand(),
              ),
            ),
          PlayerEpisodePanel(
            controller: controller,
            visible: showEpisodePanel,
            onClose: onClosePanels,
          ),
          PlayerMorePanel(
            controller: controller,
            visible: showMorePanel,
            onClose: onClosePanels,
            onOpenSettings: onOpenSettings,
            onToggleHorizontalFlip: onToggleHorizontalFlip,
            onToggleVerticalFlip: onToggleVerticalFlip,
            flipHorizontal: flipHorizontal,
            flipVertical: flipVertical,
          ),
        ],
      );
    });
  }
}

class _PlayerSideActionsOverlay extends StatelessWidget {
  final bool visible;
  final bool isCapturingScreenshot;
  final VoidCallback onScreenshot;
  final VoidCallback onToggleLock;

  const _PlayerSideActionsOverlay({
    required this.visible,
    required this.isCapturingScreenshot,
    required this.onScreenshot,
    required this.onToggleLock,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: kPlayerOverlayAnimationDuration,
      child: IgnorePointer(
        ignoring: !visible,
        child: PlayerSideSafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: PlayerSideScreenshotButton(
                    isLoading: isCapturingScreenshot,
                    onPressed: onScreenshot,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: PlayerSideLockButton(
                    isLocked: false,
                    onPressed: onToggleLock,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
