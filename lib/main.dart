import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/pixelplay_app.dart';
import 'features/settings/data/shared_preferences_settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final settingsRepository = SharedPreferencesSettingsRepository(
    preferences: preferences,
  );

  runApp(PixelPlayApp(settingsRepository: settingsRepository));
}
