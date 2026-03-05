import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

class InMemorySettingsRepository implements SettingsRepository {
  AppSettings _settings = const AppSettings();

  @override
  AppSettings load() => _settings;

  @override
  void save(AppSettings settings) {
    _settings = settings;
  }
}

