import '../presentation/favorite_models.dart';

abstract interface class FavoritesRepository {
  List<FavoriteFolderEntry> loadFolders();

  FavoriteFolderEntry createFolder({required String title, DateTime? now});

  FavoriteFolderEntry renameFolder({
    required String folderId,
    required String title,
  });

  void deleteFolders(Set<String> folderIds);

  void addVideoToFolders({
    required FavoriteVideoEntry video,
    required Set<String> folderIds,
  });

  void removeVideoFromFolders({
    required FavoriteVideoEntry video,
    required Set<String> folderIds,
  });
}
