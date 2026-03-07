import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/player_controller.dart';

class PlayerGestureLayer extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onTap;
  final bool interactionsEnabled;

  const PlayerGestureLayer({
    super.key,
    required this.controller,
    required this.onTap,
    required this.interactionsEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          onDoubleTap: interactionsEnabled ? controller.togglePlay : null,
          onLongPressStart: interactionsEnabled
              ? (_) {
                  HapticFeedback.mediumImpact();
                  controller.beginLongPressSpeedBoost();
                }
              : null,
          onLongPressEnd: interactionsEnabled
              ? (_) => controller.endLongPressSpeedBoost()
              : null,
          onScaleStart: (ScaleStartDetails details) {
            if (!interactionsEnabled) {
              return;
            }
            controller.beginSurfaceGesture(
              localPosition: details.localFocalPoint,
              viewportSize: viewportSize,
              pointerCount: details.pointerCount,
            );
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            if (!interactionsEnabled) {
              return;
            }
            controller.updateSurfaceGesture(
              localPosition: details.localFocalPoint,
              pointerCount: details.pointerCount,
              scale: details.scale,
              rotation: details.rotation,
            );
          },
          onScaleEnd: (_) {
            if (!interactionsEnabled) {
              return;
            }
            controller.endSurfaceGesture();
          },
        );
      },
    );
  }
}
