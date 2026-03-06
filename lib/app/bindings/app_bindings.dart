import 'package:get/get.dart';

import '../../features/media_library/domain/contracts/media_library_repository.dart';
import '../../features/media_library/presentation/controllers/media_library_controller.dart';
import '../../features/player_core/domain/player_controller.dart';
import '../../features/settings/domain/settings_controller.dart';
import '../../features/settings/domain/settings_repository.dart';

class AppBindings extends Bindings {
  final SettingsRepository settingsRepository;
  final MediaLibraryRepository mediaLibraryRepository;

  AppBindings({
    required this.settingsRepository,
    required this.mediaLibraryRepository,
  });

  @override
  void dependencies() {
    Get.put<SettingsRepository>(settingsRepository, permanent: true);
    Get.put<MediaLibraryRepository>(mediaLibraryRepository, permanent: true);
    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
      permanent: true,
    );
    Get.put<MediaLibraryController>(
      MediaLibraryController(repository: mediaLibraryRepository),
      permanent: true,
    );
    Get.put<PlayerController>(PlayerController(), permanent: true);
  }
}
