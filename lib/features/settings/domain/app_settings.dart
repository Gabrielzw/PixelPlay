import 'package:flutter/material.dart';

const double kDefaultPlaybackSpeed = 1.0;
const PlayerAspectRatio kDefaultAspectRatio = PlayerAspectRatio.fit;
const int kDefaultGestureSeekSecondsPerSwipe = 60;
const bool kDefaultRememberPlaybackPosition = true;
const bool kDefaultAutoPlayNext = true;

const List<double> kPlaybackSpeedOptions = <double>[
  0.5,
  0.75,
  1.0,
  1.25,
  1.5,
  2.0,
];

const int kGestureSeekMinSeconds = 10;
const int kGestureSeekMaxSeconds = 180;
const int kGestureSeekStepSeconds = 10;
const int kGestureSeekDivisions =
    (kGestureSeekMaxSeconds - kGestureSeekMinSeconds) ~/
    kGestureSeekStepSeconds;

enum PlayerAspectRatio { fit, fill, original }

extension PlayerAspectRatioLabel on PlayerAspectRatio {
  String get label {
    return switch (this) {
      PlayerAspectRatio.fit => '适应屏幕',
      PlayerAspectRatio.fill => '拉伸填充',
      PlayerAspectRatio.original => '原始比例',
    };
  }
}

@immutable
class AppSettings {
  final ThemeMode themeMode;
  final double defaultPlaybackSpeed;
  final PlayerAspectRatio defaultAspectRatio;
  final int gestureSeekSecondsPerSwipe;
  final bool rememberPlaybackPosition;
  final bool autoPlayNext;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.defaultPlaybackSpeed = kDefaultPlaybackSpeed,
    this.defaultAspectRatio = kDefaultAspectRatio,
    this.gestureSeekSecondsPerSwipe = kDefaultGestureSeekSecondsPerSwipe,
    this.rememberPlaybackPosition = kDefaultRememberPlaybackPosition,
    this.autoPlayNext = kDefaultAutoPlayNext,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    double? defaultPlaybackSpeed,
    PlayerAspectRatio? defaultAspectRatio,
    int? gestureSeekSecondsPerSwipe,
    bool? rememberPlaybackPosition,
    bool? autoPlayNext,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      defaultPlaybackSpeed: defaultPlaybackSpeed ?? this.defaultPlaybackSpeed,
      defaultAspectRatio: defaultAspectRatio ?? this.defaultAspectRatio,
      gestureSeekSecondsPerSwipe:
          gestureSeekSecondsPerSwipe ?? this.gestureSeekSecondsPerSwipe,
      rememberPlaybackPosition:
          rememberPlaybackPosition ?? this.rememberPlaybackPosition,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
    );
  }
}

