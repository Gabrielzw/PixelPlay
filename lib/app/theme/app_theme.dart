import 'package:flutter/material.dart';

const Color kPixelPlaySeedColor = Color(0xFFE11D48);
const Color kPixelPlayDarkBackground = Color(0xFF000000);

class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kPixelPlaySeedColor,
      brightness: Brightness.light,
    );

    return ThemeData(useMaterial3: true, colorScheme: colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kPixelPlaySeedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: kPixelPlayDarkBackground,
      appBarTheme: const AppBarTheme(backgroundColor: kPixelPlayDarkBackground),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: kPixelPlayDarkBackground,
      ),
    );
  }
}
