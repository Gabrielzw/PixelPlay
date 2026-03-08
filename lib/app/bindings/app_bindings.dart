import 'package:get/get.dart';

import '../../features/media_library/data/pigeon/media_store_albums_api.g.dart'
    as pigeon;
import '../../features/media_library/domain/contracts/media_library_repository.dart';
import '../../features/media_library/presentation/controllers/media_library_controller.dart';
import '../../features/player_core/domain/playback_position_repository.dart';
import '../../features/settings/domain/settings_controller.dart';
import '../../features/settings/domain/settings_repository.dart';
import '../../features/thumbnail_engine/data/native_thumbnail_store.dart';
import '../../features/thumbnail_engine/data/queued_thumbnail_queue.dart';
import '../../features/thumbnail_engine/domain/thumbnail_queue.dart';
import '../../features/watch_history/domain/watch_history_repository.dart';
import '../../features/webdav_client/domain/contracts/webdav_account_repository.dart';
import '../../features/webdav_client/domain/contracts/webdav_browser_repository.dart';
import '../../features/webdav_client/presentation/controllers/webdav_accounts_controller.dart';

class AppBindings extends Bindings {
  final SettingsRepository settingsRepository;
  final MediaLibraryRepository mediaLibraryRepository;
  final ThumbnailQueue? thumbnailQueue;
  final PlaybackPositionRepository playbackPositionRepository;
  final WatchHistoryRepository watchHistoryRepository;
  final WebDavAccountRepository webDavAccountRepository;
  final WebDavBrowserRepository webDavBrowserRepository;

  AppBindings({
    required this.settingsRepository,
    required this.mediaLibraryRepository,
    this.thumbnailQueue,
    required this.playbackPositionRepository,
    required this.watchHistoryRepository,
    required this.webDavAccountRepository,
    required this.webDavBrowserRepository,
  });

  @override
  void dependencies() {
    Get.put<SettingsRepository>(settingsRepository, permanent: true);
    Get.put<MediaLibraryRepository>(mediaLibraryRepository, permanent: true);
    Get.put<PlaybackPositionRepository>(
      playbackPositionRepository,
      permanent: true,
    );
    Get.put<WatchHistoryRepository>(watchHistoryRepository, permanent: true);
    Get.put<WebDavAccountRepository>(webDavAccountRepository, permanent: true);
    Get.put<WebDavBrowserRepository>(webDavBrowserRepository, permanent: true);
    Get.put<ThumbnailQueue>(
      thumbnailQueue ?? _buildThumbnailQueue(),
      permanent: true,
    );
    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
      permanent: true,
    );
    Get.put<MediaLibraryController>(
      MediaLibraryController(repository: mediaLibraryRepository),
      permanent: true,
    );
    Get.put<WebDavAccountsController>(
      WebDavAccountsController(repository: webDavAccountRepository),
      permanent: true,
    );
  }
}

ThumbnailQueue _buildThumbnailQueue() {
  return QueuedThumbnailQueue(
    store: NativeThumbnailStore(api: pigeon.MediaStoreAlbumsApi()),
  );
}
