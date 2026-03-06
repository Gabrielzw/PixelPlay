import '../entities/local_album.dart';
import '../entities/local_video.dart';

abstract interface class MediaLibraryRepository {
  Future<bool> hasVideoPermission();
  Future<bool> requestVideoPermission();
  Future<List<LocalAlbum>> loadLocalAlbums();
  Future<List<LocalVideo>> loadAlbumVideos(String bucketId);
}
