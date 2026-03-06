import 'package:flutter/material.dart';

import '../../domain/player_controller.dart';

class PlayerGestureLayer extends StatelessWidget {
  final PlayerController controller;

  const PlayerGestureLayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: controller.handleSurfaceTap,
          onPanStart: (DragStartDetails details) {
            controller.beginSurfaceGesture(
              localPosition: details.localPosition,
              viewportSize: viewportSize,
            );
          },
          onPanUpdate: (DragUpdateDetails details) {
            controller.updateSurfaceGesture(
              localPosition: details.localPosition,
            );
          },
          onPanEnd: (_) => controller.endSurfaceGesture(),
          onPanCancel: controller.endSurfaceGesture,
        );
      },
    );
  }
}
