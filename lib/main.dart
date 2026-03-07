import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:media_kit/media_kit.dart';

import 'app/pixelplay_app.dart';
import 'features/media_library/data/android_media_library_repository.dart';
import 'features/player_core/data/isar_playback_position_repository.dart';
import 'features/settings/data/isar_settings_repository.dart';
import 'features/webdav_client/data/isar_webdav_account_repository.dart';
import 'features/webdav_client/data/secure_storage_webdav_password_store.dart';
import 'features/webdav_client/data/webdav_client_browser_repository.dart';
import 'shared/data/isar/pixelplay_isar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  final isar = await openPixelPlayIsar();
  final settingsRepository = IsarSettingsRepository(isar: isar);
  final playbackPositionRepository = IsarPlaybackPositionRepository(isar: isar);
  final mediaLibraryRepository = AndroidMediaLibraryRepository(isar: isar);
  const secureStorage = FlutterSecureStorage();
  final webDavAccountRepository = IsarWebDavAccountRepository(
    isar: isar,
    passwordStore: const SecureStorageWebDavPasswordStore(
      storage: secureStorage,
    ),
  );
  const webDavBrowserRepository = WebDavClientBrowserRepository();

  runApp(
    PixelPlayApp(
      settingsRepository: settingsRepository,
      mediaLibraryRepository: mediaLibraryRepository,
      playbackPositionRepository: playbackPositionRepository,
      webDavAccountRepository: webDavAccountRepository,
      webDavBrowserRepository: webDavBrowserRepository,
    ),
  );
}
