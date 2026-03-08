import '../domain/favorites_repository.dart';
import '../presentation/favorite_models.dart';

class InMemoryFavoritesRepository implements FavoritesRepository {
  final List<FavoriteFolderEntry> _folders;

  InMemoryFavoritesRepository({List<FavoriteFolderEntry>? initialFolders})
    : _folders = List<FavoriteFolderEntry>.of(
        initialFolders ?? buildInitialFavoriteFolders(),
      );

  @override
  List<FavoriteFolderEntry> loadFolders() {
    return List<FavoriteFolderEntry>.unmodifiable(_folders);
  }

  @override
  FavoriteFolderEntry createFolder({required String title, DateTime? now}) {
    final createdAt = now ?? DateTime.now();
    final folder = FavoriteFolderEntry(
      id: 'favorite-folder-${createdAt.microsecondsSinceEpoch}',
      title: title.trim(),
      createdAt: createdAt,
      videos: const <FavoriteVideoEntry>[],
    );
    _folders.add(folder);
    return folder;
  }

  @override
  void deleteFolders(Set<String> folderIds) {
    _folders.removeWhere(
      (FavoriteFolderEntry folder) => folderIds.contains(folder.id),
    );
  }

  @override
  void addVideoToFolders({
    required FavoriteVideoEntry video,
    required Set<String> folderIds,
  }) {
    for (var index = 0; index < _folders.length; index++) {
      final folder = _folders[index];
      if (!folderIds.contains(folder.id)) {
        continue;
      }

      final nextVideos = List<FavoriteVideoEntry>.of(folder.videos);
      final existingIndex = nextVideos.indexWhere(
        (FavoriteVideoEntry item) => item.id == video.id,
      );
      if (existingIndex >= 0) {
        nextVideos[existingIndex] = video;
      } else {
        nextVideos.add(video);
      }

      _folders[index] = FavoriteFolderEntry(
        id: folder.id,
        title: folder.title,
        createdAt: folder.createdAt,
        videos: nextVideos,
      );
    }
  }
}
