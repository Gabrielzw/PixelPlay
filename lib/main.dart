import 'package:flutter/material.dart';

import 'app/pixelplay_app.dart';
import 'app/settings/app_settings_controller.dart';
import 'app/settings/app_settings_scope.dart';
import 'app/settings/app_settings_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = AppSettingsController(const AppSettingsState());
  runApp(
    AppSettingsScope(
      controller: settingsController,
      child: const PixelPlayApp(),
    ),
  );
}
