import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/pixelplay_app.dart';
import 'features/media_library/data/android_media_library_repository.dart';
import 'features/settings/data/shared_preferences_settings_repository.dart';
import 'features/webdav_client/data/secure_storage_webdav_password_store.dart';
import 'features/webdav_client/data/shared_preferences_webdav_account_repository.dart';
import 'features/webdav_client/data/webdav_client_browser_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final settingsRepository = SharedPreferencesSettingsRepository(
    preferences: preferences,
  );
  final mediaLibraryRepository = AndroidMediaLibraryRepository();
  const secureStorage = FlutterSecureStorage();
  final webDavAccountRepository = SharedPreferencesWebDavAccountRepository(
    preferences: preferences,
    passwordStore: const SecureStorageWebDavPasswordStore(
      storage: secureStorage,
    ),
  );
  const webDavBrowserRepository = WebDavClientBrowserRepository();

  runApp(
    PixelPlayApp(
      settingsRepository: settingsRepository,
      mediaLibraryRepository: mediaLibraryRepository,
      webDavAccountRepository: webDavAccountRepository,
      webDavBrowserRepository: webDavBrowserRepository,
    ),
  );
}
