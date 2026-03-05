import 'app_settings.dart';

abstract interface class SettingsRepository {
  AppSettings load();
  void save(AppSettings settings);
}

