import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/shell/presentation/pixelplay_shell.dart';
import 'bindings/app_bindings.dart';
import 'theme/app_theme.dart';

class PixelPlayApp extends StatelessWidget {
  const PixelPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PixelPlay',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialBinding: AppBindings(),
      home: const PixelPlayShell(),
    );
  }
}
