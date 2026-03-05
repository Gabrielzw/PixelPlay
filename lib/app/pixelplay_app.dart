import 'package:flutter/material.dart';

import '../features/shell/presentation/pixelplay_shell.dart';
import 'settings/app_settings_scope.dart';
import 'theme/app_theme.dart';

class PixelPlayApp extends StatelessWidget {
  const PixelPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context).value;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PixelPlay',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      home: const PixelPlayShell(),
    );
  }
}
