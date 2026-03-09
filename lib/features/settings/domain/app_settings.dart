import 'package:flutter/material.dart';

const int kDefaultSeedColorValue = 0xFFE7A2BA;
const double kDefaultPlaybackSpeed = 1.0;
const double kDefaultLongPressPlaybackSpeed = 2.0;
const PlayerAspectRatio kDefaultAspectRatio = PlayerAspectRatio.fit;
const PlayerPlaybackMode kDefaultPlaybackMode = PlayerPlaybackMode.noLoop;
const int kDefaultGestureSeekSecondsPerSwipe = 60;
const bool kDefaultGestureSeekUsesVideoDuration = false;
const bool kDefaultRememberPlaybackPosition = true;
const bool kDefaultAutoPlayOnEnter = true;

const List<double> kPlaybackSpeedOptions = <double>[
  0.25,
  0.5,
  0.75,
  1.0,
  1.25,
  1.5,
  1.75,
  2.0,
  2.25,
  2.5,
  2.75,
  3.0,
  3.25,
  3.5,
  3.75,
  4.0,
  4.25,
  4.5,
  4.75,
  5.0,
];

const List<double> kLongPressSpeedOptions = <double>[2.0, 3.0, 4.0, 5.0];

const int kGestureSeekMinSeconds = 10;
const int kGestureSeekMaxSeconds = 180;
const int kGestureSeekStepSeconds = 10;
const int kGestureSeekDivisions =
    (kGestureSeekMaxSeconds - kGestureSeekMinSeconds) ~/
    kGestureSeekStepSeconds;

enum PlayerAspectRatio { fit, fill, original, crop }

enum PlayerPlaybackMode { loopList, loopSingle, noLoop }

extension PlayerAspectRatioLabel on PlayerAspectRatio {
  String get label {
    return switch (this) {
      PlayerAspectRatio.fit => '适应',
      PlayerAspectRatio.fill => '拉伸',
      PlayerAspectRatio.original => '原始',
      PlayerAspectRatio.crop => '裁剪',
    };
  }

  IconData get icon {
    return switch (this) {
      PlayerAspectRatio.fit => Icons.fit_screen_rounded,
      PlayerAspectRatio.fill => Icons.fullscreen_rounded,
      PlayerAspectRatio.original => Icons.crop_original_rounded,
      PlayerAspectRatio.crop => Icons.crop_rounded,
    };
  }
}

extension PlayerPlaybackModeLabel on PlayerPlaybackMode {
  String get label {
    return switch (this) {
      PlayerPlaybackMode.loopList => '列表循环',
      PlayerPlaybackMode.loopSingle => '单集循环',
      PlayerPlaybackMode.noLoop => '播完停止',
    };
  }

  IconData get icon {
    return switch (this) {
      PlayerPlaybackMode.loopList => Icons.repeat_rounded,
      PlayerPlaybackMode.loopSingle => Icons.repeat_one_rounded,
      PlayerPlaybackMode.noLoop => Icons.stop_circle_outlined,
    };
  }
}

@immutable
class AppSettings {
  final ThemeMode themeMode;
  final int seedColorValue;
  final double defaultPlaybackSpeed;
  final double longPressPlaybackSpeed;
  final PlayerAspectRatio defaultAspectRatio;
  final PlayerPlaybackMode defaultPlaybackMode;
  final int gestureSeekSecondsPerSwipe;
  final bool gestureSeekUsesVideoDuration;
  final bool rememberPlaybackPosition;
  final bool autoPlayOnEnter;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.seedColorValue = kDefaultSeedColorValue,
    this.defaultPlaybackSpeed = kDefaultPlaybackSpeed,
    this.longPressPlaybackSpeed = kDefaultLongPressPlaybackSpeed,
    this.defaultAspectRatio = kDefaultAspectRatio,
    this.defaultPlaybackMode = kDefaultPlaybackMode,
    this.gestureSeekSecondsPerSwipe = kDefaultGestureSeekSecondsPerSwipe,
    this.gestureSeekUsesVideoDuration = kDefaultGestureSeekUsesVideoDuration,
    this.rememberPlaybackPosition = kDefaultRememberPlaybackPosition,
    this.autoPlayOnEnter = kDefaultAutoPlayOnEnter,
  });

  Color get seedColor => Color(seedColorValue);

  AppSettings copyWith({
    ThemeMode? themeMode,
    int? seedColorValue,
    double? defaultPlaybackSpeed,
    double? longPressPlaybackSpeed,
    PlayerAspectRatio? defaultAspectRatio,
    PlayerPlaybackMode? defaultPlaybackMode,
    int? gestureSeekSecondsPerSwipe,
    bool? gestureSeekUsesVideoDuration,
    bool? rememberPlaybackPosition,
    bool? autoPlayOnEnter,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      seedColorValue: seedColorValue ?? this.seedColorValue,
      defaultPlaybackSpeed: defaultPlaybackSpeed ?? this.defaultPlaybackSpeed,
      longPressPlaybackSpeed:
          longPressPlaybackSpeed ?? this.longPressPlaybackSpeed,
      defaultAspectRatio: defaultAspectRatio ?? this.defaultAspectRatio,
      defaultPlaybackMode: defaultPlaybackMode ?? this.defaultPlaybackMode,
      gestureSeekSecondsPerSwipe:
          gestureSeekSecondsPerSwipe ?? this.gestureSeekSecondsPerSwipe,
      gestureSeekUsesVideoDuration:
          gestureSeekUsesVideoDuration ?? this.gestureSeekUsesVideoDuration,
      rememberPlaybackPosition:
          rememberPlaybackPosition ?? this.rememberPlaybackPosition,
      autoPlayOnEnter: autoPlayOnEnter ?? this.autoPlayOnEnter,
    );
  }
}
