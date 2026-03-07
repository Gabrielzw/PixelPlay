import 'package:flutter/material.dart';

import 'player_ui_constants.dart';

class PlayerSlidePanel extends StatelessWidget {
  final bool visible;
  final Widget child;
  final double landscapeWidth;
  final double portraitHeightFactor;

  const PlayerSlidePanel({
    super.key,
    required this.visible,
    required this.child,
    this.landscapeWidth = 360,
    this.portraitHeightFactor = 0.62,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedSlide(
        offset: visible
            ? Offset.zero
            : isLandscape
            ? const Offset(1, 0)
            : const Offset(0, 1),
        duration: kPlayerOverlayAnimationDuration,
        curve: Curves.easeOutCubic,
        child: Align(
          alignment: isLandscape
              ? Alignment.centerRight
              : Alignment.bottomCenter,
          child: SizedBox(
            width: isLandscape ? landscapeWidth : null,
            height: isLandscape ? null : size.height * portraitHeightFactor,
            child: child,
          ),
        ),
      ),
    );
  }
}
