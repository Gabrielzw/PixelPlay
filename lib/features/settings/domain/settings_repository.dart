import 'app_settings.dart';

abstract interface class SettingsRepository {
  AppSettings load();
  Future<void> save(AppSettings settings);
}
