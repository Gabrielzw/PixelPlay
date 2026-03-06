import 'video_thumbnail_request.dart';

abstract interface class ThumbnailStore {
  Future<String> resolveThumbnail(VideoThumbnailRequest request);
  Future<void> clearCache();
}
