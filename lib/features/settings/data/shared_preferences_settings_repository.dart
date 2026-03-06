import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

const String kThemeModeKey = 'settings.theme_mode';
const String kSeedColorKey = 'settings.seed_color';
const String kPlaybackSpeedKey = 'settings.playback_speed';
const String kAspectRatioKey = 'settings.aspect_ratio';
const String kGestureSeekKey = 'settings.gesture_seek_seconds';
const String kRememberPlaybackPositionKey =
    'settings.remember_playback_position';
const String kAutoPlayNextKey = 'settings.auto_play_next';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  final SharedPreferences preferences;

  const SharedPreferencesSettingsRepository({required this.preferences});

  @override
  AppSettings load() {
    return AppSettings(
      themeMode: _readThemeMode(),
      seedColorValue:
          preferences.getInt(kSeedColorKey) ?? kDefaultSeedColorValue,
      defaultPlaybackSpeed:
          preferences.getDouble(kPlaybackSpeedKey) ?? kDefaultPlaybackSpeed,
      defaultAspectRatio: _readAspectRatio(),
      gestureSeekSecondsPerSwipe:
          preferences.getInt(kGestureSeekKey) ??
          kDefaultGestureSeekSecondsPerSwipe,
      rememberPlaybackPosition:
          preferences.getBool(kRememberPlaybackPositionKey) ??
          kDefaultRememberPlaybackPosition,
      autoPlayNext:
          preferences.getBool(kAutoPlayNextKey) ?? kDefaultAutoPlayNext,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    final results = await Future.wait<bool>(<Future<bool>>[
      preferences.setString(kThemeModeKey, settings.themeMode.name),
      preferences.setInt(kSeedColorKey, settings.seedColorValue),
      preferences.setDouble(kPlaybackSpeedKey, settings.defaultPlaybackSpeed),
      preferences.setString(kAspectRatioKey, settings.defaultAspectRatio.name),
      preferences.setInt(kGestureSeekKey, settings.gestureSeekSecondsPerSwipe),
      preferences.setBool(
        kRememberPlaybackPositionKey,
        settings.rememberPlaybackPosition,
      ),
      preferences.setBool(kAutoPlayNextKey, settings.autoPlayNext),
    ]);

    if (results.any((bool result) => result == false)) {
      throw StateError('Failed to persist app settings.');
    }
  }

  ThemeMode _readThemeMode() {
    final storedValue = preferences.getString(kThemeModeKey);

    return ThemeMode.values.firstWhere(
      (ThemeMode mode) => mode.name == storedValue,
      orElse: () => ThemeMode.system,
    );
  }

  PlayerAspectRatio _readAspectRatio() {
    final storedValue = preferences.getString(kAspectRatioKey);

    return PlayerAspectRatio.values.firstWhere(
      (PlayerAspectRatio ratio) => ratio.name == storedValue,
      orElse: () => kDefaultAspectRatio,
    );
  }
}
