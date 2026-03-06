import '../entities/local_album.dart';

abstract interface class MediaLibraryRepository {
  Future<bool> hasVideoPermission();
  Future<bool> requestVideoPermission();
  Future<List<LocalAlbum>> loadLocalAlbums();
}

