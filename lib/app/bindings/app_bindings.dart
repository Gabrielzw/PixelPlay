import 'package:get/get.dart';

import '../../features/player_core/domain/player_controller.dart';
import '../../features/settings/domain/settings_controller.dart';
import '../../features/settings/domain/settings_repository.dart';

class AppBindings extends Bindings {
  final SettingsRepository settingsRepository;

  AppBindings({required this.settingsRepository});

  @override
  void dependencies() {
    Get.put<SettingsRepository>(settingsRepository, permanent: true);
    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
      permanent: true,
    );
    Get.put<PlayerController>(PlayerController(), permanent: true);
  }
}
