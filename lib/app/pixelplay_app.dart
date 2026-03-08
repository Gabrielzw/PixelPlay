import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../features/media_library/domain/contracts/media_library_repository.dart';
import '../features/favorites/domain/favorites_repository.dart';
import '../features/player_core/domain/playback_position_repository.dart';
import '../features/settings/domain/settings_controller.dart';
import '../features/settings/domain/settings_repository.dart';
import '../features/shell/presentation/pixelplay_shell.dart';
import '../features/thumbnail_engine/domain/thumbnail_queue.dart';
import '../features/watch_history/domain/watch_history_repository.dart';
import '../features/webdav_client/domain/contracts/webdav_account_repository.dart';
import '../features/webdav_client/domain/contracts/webdav_browser_repository.dart';
import 'bindings/app_bindings.dart';
import 'theme/app_theme.dart';

class PixelPlayApp extends StatefulWidget {
  final SettingsRepository settingsRepository;
  final MediaLibraryRepository mediaLibraryRepository;
  final ThumbnailQueue? thumbnailQueue;
  final FavoritesRepository? favoritesRepository;
  final PlaybackPositionRepository playbackPositionRepository;
  final WatchHistoryRepository watchHistoryRepository;
  final WebDavAccountRepository webDavAccountRepository;
  final WebDavBrowserRepository webDavBrowserRepository;

  const PixelPlayApp({
    super.key,
    required this.settingsRepository,
    required this.mediaLibraryRepository,
    this.thumbnailQueue,
    this.favoritesRepository,
    required this.playbackPositionRepository,
    required this.watchHistoryRepository,
    required this.webDavAccountRepository,
    required this.webDavBrowserRepository,
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
      thumbnailQueue: widget.thumbnailQueue,
      favoritesRepository: widget.favoritesRepository,
      playbackPositionRepository: widget.playbackPositionRepository,
      watchHistoryRepository: widget.watchHistoryRepository,
      webDavAccountRepository: widget.webDavAccountRepository,
      webDavBrowserRepository: widget.webDavBrowserRepository,
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
      navigatorObservers: <NavigatorObserver>[FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(
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
      ),
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
