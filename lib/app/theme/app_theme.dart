import 'package:flutter/material.dart';

import '../../features/settings/domain/app_settings.dart';

const Color kPixelPlayLightBackground = Color(0xFFF8F4F6);
const Color kPixelPlayDarkBackground = Color(0xFF121014);
const double kPixelPlayTopRadius = 28;
const int kThemeAnimationDurationMs = 220;

class AppTheme {
  static ThemeData light({
    Color seedColor = const Color(kDefaultSeedColorValue),
  }) {
    return _themeData(
      seedColor: seedColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: kPixelPlayLightBackground,
    );
  }

  static ThemeData dark({
    Color seedColor = const Color(kDefaultSeedColorValue),
  }) {
    return _themeData(
      seedColor: seedColor,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kPixelPlayDarkBackground,
    );
  }

  static ThemeData _themeData({
    required Color seedColor,
    required Brightness brightness,
    required Color scaffoldBackgroundColor,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
    );

    return baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: Colors.transparent,
      ),
      snackBarTheme: baseTheme.snackBarTheme.copyWith(
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: baseTheme.dividerTheme.copyWith(
        color: colorScheme.outlineVariant,
      ),
    );
  }
}
