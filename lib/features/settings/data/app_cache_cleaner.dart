import '../../player_core/domain/playback_position_repository.dart';
import '../../thumbnail_engine/domain/thumbnail_queue.dart';
import '../domain/cache_cleaner.dart';

class AppCacheCleaner implements CacheCleaner {
  final ThumbnailQueue thumbnailQueue;
  final PlaybackPositionRepository playbackPositionRepository;

  const AppCacheCleaner({
    required this.thumbnailQueue,
    required this.playbackPositionRepository,
  });

  @override
  Future<void> clearAll() async {
    await thumbnailQueue.clearCache();
    await playbackPositionRepository.clearAll();
  }
}
