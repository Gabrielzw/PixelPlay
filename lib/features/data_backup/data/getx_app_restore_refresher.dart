import 'package:get/get.dart';

import '../../favorites/presentation/controllers/favorites_controller.dart';
import '../../playlist_sources/presentation/controllers/playlist_sources_controller.dart';
import '../../settings/domain/settings_controller.dart';
import '../../webdav_client/presentation/controllers/webdav_accounts_controller.dart';
import '../domain/app_restore_refresher.dart';

class GetxAppRestoreRefresher implements AppRestoreRefresher {
  const GetxAppRestoreRefresher();

  @override
  Future<void> refreshRestoredData() async {
    Get.find<SettingsController>().reload();
    Get.find<FavoritesController>().refreshFolders();
    Get.find<PlaylistSourcesController>().refreshEntries();
    await Get.find<WebDavAccountsController>().refreshAccounts();
  }
}
