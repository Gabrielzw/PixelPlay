import 'video_thumbnail_request.dart';

abstract interface class ThumbnailQueue {
  String? cachedPath(String cacheKey);
  Future<String> enqueue(VideoThumbnailRequest request, {int priority = 0});
  void cancel(String cacheKey);
  Future<void> clearCache();
}
