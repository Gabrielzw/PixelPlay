import 'package:flutter/material.dart';

const double kMediaLibraryCardShadowBlur = 18;
const double kMediaLibraryCardShadowOffsetY = 10;
const double kMediaLibraryCardShadowOpacity = 0.08;

BoxDecoration buildMediaLibraryCardDecoration(double borderRadius) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withValues(alpha: kMediaLibraryCardShadowOpacity),
        blurRadius: kMediaLibraryCardShadowBlur,
        offset: const Offset(0, kMediaLibraryCardShadowOffsetY),
      ),
    ],
  );
}
