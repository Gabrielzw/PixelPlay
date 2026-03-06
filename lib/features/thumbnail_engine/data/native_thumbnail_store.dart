import '../../media_library/data/pigeon/media_store_albums_api.g.dart'
    as pigeon;
import '../domain/thumbnail_store.dart';
import '../domain/video_thumbnail_request.dart';

class NativeThumbnailStore implements ThumbnailStore {
  final pigeon.MediaStoreAlbumsApi api;

  NativeThumbnailStore({pigeon.MediaStoreAlbumsApi? api})
    : api = api ?? pigeon.MediaStoreAlbumsApi();

  @override
  Future<String> resolveThumbnail(VideoThumbnailRequest request) {
    final nativeRequest = pigeon.NativeThumbnailRequest(
      videoId: request.videoId,
      videoPath: request.videoPath,
      targetWidth: request.targetWidth,
      targetHeight: request.targetHeight,
      dateModified: request.dateModified,
    );
    return api.resolveVideoThumbnail(nativeRequest);
  }

  @override
  Future<void> clearCache() {
    return api.clearThumbnailCache();
  }
}
