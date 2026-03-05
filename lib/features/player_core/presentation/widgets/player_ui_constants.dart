import 'package:flutter/material.dart';

const Color kPlayerBackground = Colors.black;
const double kPlayerMinProgress = 0;
const double kPlayerMaxProgress = 1;
const int kColorAlphaMax = 255;

const double kPlayerIconOpacity = 0.8;
const double kPlayerTopGradientStartOpacity = 0.72;
const double kPlayerBottomGradientEndOpacity = 0.82;
const double kPlayerLockedHintOpacity = 0.55;

Color applyOpacity(Color color, double opacity) {
  return color.withAlpha((opacity * kColorAlphaMax).round());
}

