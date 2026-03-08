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
  double? longPressPlaybackSpeed;
  late String defaultAspectRatioName;
  String? defaultPlaybackModeName;
  late int gestureSeekSecondsPerSwipe;
  bool? gestureSeekUsesVideoDuration;
  late bool rememberPlaybackPosition;
  bool? autoPlayOnEnter;

  AppSettings toDomain() {
    return AppSettings(
      themeMode: _resolveThemeMode(themeModeName),
      seedColorValue: seedColorValue,
      defaultPlaybackSpeed: defaultPlaybackSpeed,
      longPressPlaybackSpeed:
          longPressPlaybackSpeed ?? kDefaultLongPressPlaybackSpeed,
      defaultAspectRatio: _resolveAspectRatio(defaultAspectRatioName),
      defaultPlaybackMode: _resolvePlaybackMode(defaultPlaybackModeName),
      gestureSeekSecondsPerSwipe: gestureSeekSecondsPerSwipe,
      gestureSeekUsesVideoDuration:
          gestureSeekUsesVideoDuration ?? kDefaultGestureSeekUsesVideoDuration,
      rememberPlaybackPosition: rememberPlaybackPosition,
      autoPlayOnEnter: autoPlayOnEnter ?? kDefaultAutoPlayOnEnter,
    );
  }

  static AppSettingsIsarModel fromDomain(AppSettings settings) {
    return AppSettingsIsarModel()
      ..id = kAppSettingsSingletonId
      ..themeModeName = settings.themeMode.name
      ..seedColorValue = settings.seedColorValue
      ..defaultPlaybackSpeed = settings.defaultPlaybackSpeed
      ..longPressPlaybackSpeed = settings.longPressPlaybackSpeed
      ..defaultAspectRatioName = settings.defaultAspectRatio.name
      ..defaultPlaybackModeName = settings.defaultPlaybackMode.name
      ..gestureSeekSecondsPerSwipe = settings.gestureSeekSecondsPerSwipe
      ..gestureSeekUsesVideoDuration = settings.gestureSeekUsesVideoDuration
      ..rememberPlaybackPosition = settings.rememberPlaybackPosition
      ..autoPlayOnEnter = settings.autoPlayOnEnter;
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

PlayerPlaybackMode _resolvePlaybackMode(String? value) {
  return PlayerPlaybackMode.values.firstWhere(
    (PlayerPlaybackMode mode) => mode.name == value,
    orElse: () => kDefaultPlaybackMode,
  );
}
