import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_settings.dart';
import 'settings_repository.dart';

class SettingsController extends GetxController {
  final SettingsRepository repository;
  final Rx<AppSettings> settings;

  SettingsController({required this.repository})
    : settings = repository.load().obs;

  @override
  void onInit() {
    super.onInit();
    Get.changeThemeMode(settings.value.themeMode);
  }

  void setThemeMode(ThemeMode themeMode) {
    settings.value = settings.value.copyWith(themeMode: themeMode);
    repository.save(settings.value);
    Get.changeThemeMode(themeMode);
  }

  void setDefaultPlaybackSpeed(double speed) {
    settings.value = settings.value.copyWith(defaultPlaybackSpeed: speed);
    repository.save(settings.value);
  }

  void setDefaultAspectRatio(PlayerAspectRatio aspectRatio) {
    settings.value = settings.value.copyWith(defaultAspectRatio: aspectRatio);
    repository.save(settings.value);
  }

  void setGestureSeekSecondsPerSwipe(int seconds) {
    settings.value = settings.value.copyWith(gestureSeekSecondsPerSwipe: seconds);
    repository.save(settings.value);
  }

  void setRememberPlaybackPosition(bool enabled) {
    settings.value = settings.value.copyWith(rememberPlaybackPosition: enabled);
    repository.save(settings.value);
  }

  void setAutoPlayNext(bool enabled) {
    settings.value = settings.value.copyWith(autoPlayNext: enabled);
    repository.save(settings.value);
  }
}

