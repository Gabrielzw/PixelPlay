import 'package:flutter/material.dart';

import 'app_settings_state.dart';

class AppSettingsController extends ValueNotifier<AppSettingsState> {
  AppSettingsController(super.value);

  void setThemeMode(ThemeMode themeMode) {
    value = value.copyWith(themeMode: themeMode);
  }

  void setDefaultPlaybackSpeed(double speed) {
    value = value.copyWith(defaultPlaybackSpeed: speed);
  }

  void setDefaultAspectRatio(PlayerAspectRatio aspectRatio) {
    value = value.copyWith(defaultAspectRatio: aspectRatio);
  }

  void setGestureSeekSecondsPerSwipe(int seconds) {
    value = value.copyWith(gestureSeekSecondsPerSwipe: seconds);
  }

  void setRememberPlaybackPosition(bool enabled) {
    value = value.copyWith(rememberPlaybackPosition: enabled);
  }

  void setAutoPlayNext(bool enabled) {
    value = value.copyWith(autoPlayNext: enabled);
  }
}
