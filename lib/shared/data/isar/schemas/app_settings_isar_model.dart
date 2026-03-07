import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

import '../../../../features/settings/domain/app_settings.dart';

part 'app_settings_isar_model.g.dart';

const int kAppSettingsSingletonId = 1;

@collection
class AppSettingsIsarModel {
  Id id = kAppSettingsSingletonId;

  late String themeModeName;
  late int seedColorValue;
  late double defaultPlaybackSpeed;
  late String defaultAspectRatioName;
  late int gestureSeekSecondsPerSwipe;
  late bool rememberPlaybackPosition;
  late bool autoPlayNext;

  AppSettings toDomain() {
    return AppSettings(
      themeMode: _resolveThemeMode(themeModeName),
      seedColorValue: seedColorValue,
      defaultPlaybackSpeed: defaultPlaybackSpeed,
      defaultAspectRatio: _resolveAspectRatio(defaultAspectRatioName),
      gestureSeekSecondsPerSwipe: gestureSeekSecondsPerSwipe,
      rememberPlaybackPosition: rememberPlaybackPosition,
      autoPlayNext: autoPlayNext,
    );
  }

  static AppSettingsIsarModel fromDomain(AppSettings settings) {
    return AppSettingsIsarModel()
      ..id = kAppSettingsSingletonId
      ..themeModeName = settings.themeMode.name
      ..seedColorValue = settings.seedColorValue
      ..defaultPlaybackSpeed = settings.defaultPlaybackSpeed
      ..defaultAspectRatioName = settings.defaultAspectRatio.name
      ..gestureSeekSecondsPerSwipe = settings.gestureSeekSecondsPerSwipe
      ..rememberPlaybackPosition = settings.rememberPlaybackPosition
      ..autoPlayNext = settings.autoPlayNext;
  }
}

ThemeMode _resolveThemeMode(String value) {
  return ThemeMode.values.firstWhere(
    (ThemeMode mode) => mode.name == value,
    orElse: () => ThemeMode.system,
  );
}

PlayerAspectRatio _resolveAspectRatio(String value) {
  return PlayerAspectRatio.values.firstWhere(
    (PlayerAspectRatio ratio) => ratio.name == value,
    orElse: () => kDefaultAspectRatio,
  );
}
