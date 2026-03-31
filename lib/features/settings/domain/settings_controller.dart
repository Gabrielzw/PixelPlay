import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_settings.dart';
import 'page_transition_type.dart';
import 'settings_repository.dart';

class SettingsController extends GetxController {
  final SettingsRepository repository;
  final Rx<AppSettings> settings;

  SettingsController({required this.repository})
    : settings = repository.load().obs;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _saveSettings(settings.value.copyWith(themeMode: themeMode));
  }

  Future<void> setSeedColor(Color color) async {
    await _saveSettings(
      settings.value.copyWith(seedColorValue: color.toARGB32()),
    );
  }

  Future<void> setPageTransitionType(PageTransitionType type) async {
    await _saveSettings(settings.value.copyWith(pageTransitionType: type));
  }

  Future<void> setDefaultPlaybackSpeed(double speed) async {
    await _saveSettings(settings.value.copyWith(defaultPlaybackSpeed: speed));
  }

  Future<void> setLongPressPlaybackSpeed(double speed) async {
    await _saveSettings(settings.value.copyWith(longPressPlaybackSpeed: speed));
  }

  Future<void> setDefaultAspectRatio(PlayerAspectRatio aspectRatio) async {
    await _saveSettings(
      settings.value.copyWith(defaultAspectRatio: aspectRatio),
    );
  }

  Future<void> setDefaultPlaybackMode(PlayerPlaybackMode mode) async {
    await _saveSettings(settings.value.copyWith(defaultPlaybackMode: mode));
  }

  Future<void> setGestureSeekSecondsPerSwipe(int seconds) async {
    await _saveSettings(
      settings.value.copyWith(gestureSeekSecondsPerSwipe: seconds),
    );
  }

  Future<void> setGestureSeekUsesVideoDuration(bool enabled) async {
    await _saveSettings(
      settings.value.copyWith(gestureSeekUsesVideoDuration: enabled),
    );
  }

  Future<void> setRememberPlaybackPosition(bool enabled) async {
    await _saveSettings(
      settings.value.copyWith(rememberPlaybackPosition: enabled),
    );
  }

  Future<void> setAutoPlayOnEnter(bool enabled) async {
    await _saveSettings(settings.value.copyWith(autoPlayOnEnter: enabled));
  }

  void reload() {
    settings.value = repository.load();
  }

  Future<void> _saveSettings(AppSettings nextSettings) async {
    settings.value = nextSettings;
    await repository.save(nextSettings);
  }
}
