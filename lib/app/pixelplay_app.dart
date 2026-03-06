import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/media_library/domain/contracts/media_library_repository.dart';
import '../features/settings/domain/settings_controller.dart';
import '../features/settings/domain/settings_repository.dart';
import '../features/shell/presentation/pixelplay_shell.dart';
import 'bindings/app_bindings.dart';
import 'theme/app_theme.dart';

class PixelPlayApp extends StatefulWidget {
  final SettingsRepository settingsRepository;
  final MediaLibraryRepository mediaLibraryRepository;

  const PixelPlayApp({
    super.key,
    required this.settingsRepository,
    required this.mediaLibraryRepository,
  });

  @override
  State<PixelPlayApp> createState() => _PixelPlayAppState();
}

class _PixelPlayAppState extends State<PixelPlayApp> {
  late final SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    AppBindings(
      settingsRepository: widget.settingsRepository,
      mediaLibraryRepository: widget.mediaLibraryRepository,
    ).dependencies();
    _settingsController = Get.find<SettingsController>();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixel Play',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const PixelPlayShell(),
      builder: (BuildContext context, Widget? child) {
        return Obx(() {
          final settings = _settingsController.settings.value;
          final brightness = _resolveBrightness(
            context: context,
            themeMode: settings.themeMode,
          );
          final theme = brightness == Brightness.dark
              ? AppTheme.dark(seedColor: settings.seedColor)
              : AppTheme.light(seedColor: settings.seedColor);

          return AnimatedTheme(
            data: theme,
            duration: const Duration(milliseconds: kThemeAnimationDurationMs),
            child: child ?? const SizedBox.shrink(),
          );
        });
      },
    );
  }

  Brightness _resolveBrightness({
    required BuildContext context,
    required ThemeMode themeMode,
  }) {
    return switch (themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
    };
  }
}
