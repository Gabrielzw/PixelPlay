import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import 'pigeon/media_store_albums_api.g.dart' as pigeon;

class AndroidMediaLibraryRepository implements MediaLibraryRepository {
  final pigeon.MediaStoreAlbumsApi api;

  AndroidMediaLibraryRepository({pigeon.MediaStoreAlbumsApi? api})
    : api = api ?? pigeon.MediaStoreAlbumsApi();

  @override
  Future<bool> hasVideoPermission() => api.hasVideoPermission();

  @override
  Future<bool> requestVideoPermission() => api.requestVideoPermission();

  @override
  Future<List<LocalAlbum>> loadLocalAlbums() async {
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
}

