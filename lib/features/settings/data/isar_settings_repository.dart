import 'package:isar_community/isar.dart';

import '../../../shared/data/isar/schemas/app_settings_isar_model.dart';
import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

class IsarSettingsRepository implements SettingsRepository {
  final Isar isar;

  const IsarSettingsRepository({required this.isar});

  @override
  AppSettings load() {
    final storedSettings = isar.appSettingsIsarModels.getSync(
      kAppSettingsSingletonId,
    );
    return storedSettings?.toDomain() ?? const AppSettings();
  }

  @override
  Future<void> save(AppSettings settings) async {
    final nextSettings = AppSettingsIsarModel.fromDomain(settings);
    await isar.writeTxn(() async {
      await isar.appSettingsIsarModels.put(nextSettings);
    });
  }
}
