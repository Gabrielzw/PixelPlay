import 'package:get/get.dart';

import '../../features/player_core/domain/player_controller.dart';
import '../../features/settings/data/in_memory_settings_repository.dart';
import '../../features/settings/domain/settings_controller.dart';
import '../../features/settings/domain/settings_repository.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsRepository>(InMemorySettingsRepository(), permanent: true);
    Get.put<SettingsController>(
      SettingsController(repository: Get.find<SettingsRepository>()),
      permanent: true,
    );
    Get.put<PlayerController>(PlayerController(), permanent: true);
  }
}

