import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import '../domain/entities/local_video.dart';
import 'pigeon/media_store_albums_api.g.dart' as pigeon;

class AndroidMediaLibraryRepository implements MediaLibraryRepository {
  final pigeon.MediaStoreAlbumsApi api;
  final Map<String, List<LocalVideo>> _albumVideosCache =
      <String, List<LocalVideo>>{};

  AndroidMediaLibraryRepository({pigeon.MediaStoreAlbumsApi? api})
    : api = api ?? pigeon.MediaStoreAlbumsApi();

  @override
  Future<bool> hasVideoPermission() => api.hasVideoPermission();

  @override
  Future<bool> requestVideoPermission() => api.requestVideoPermission();

  @override
  Future<List<LocalAlbum>> loadLocalAlbums() async {
    _albumVideosCache.clear();
    final albums = await api.scanLocalVideoAlbums();
    return albums
        .map(
          (pigeon.NativeAlbumRecord record) => LocalAlbum(
            bucketId: record.bucketId,
            bucketName: record.bucketName,
            videoCount: record.videoCount,
            latestDateAddedSeconds: record.latestDateAddedSeconds,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<LocalVideo>> loadAlbumVideos(String bucketId) async {
    final cachedVideos = _albumVideosCache[bucketId];
    if (cachedVideos != null) {
      return cachedVideos;
    }

    final videos = await api.scanAlbumVideos(bucketId);
    final mappedVideos = List<LocalVideo>.unmodifiable(
      videos.map(_mapVideoRecord),
    );
    _albumVideosCache[bucketId] = mappedVideos;
    return mappedVideos;
  }

  LocalVideo _mapVideoRecord(pigeon.NativeVideoRecord record) {
    return LocalVideo(
      id: int.parse(record.id),
      path: record.path,
      title: record.name,
      bucketId: record.bucketId,
      bucketName: record.bucketName,
      durationMs: record.durationMs,
      size: record.size,
      dateAdded: record.dateAdded,
      width: record.width,
      height: record.height,
      dateModified: record.dateModified,
    );
  }
}
