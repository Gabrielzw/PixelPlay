import '../presentation/favorite_models.dart';

abstract interface class FavoritesRepository {
  List<FavoriteFolderEntry> loadFolders();

  FavoriteFolderEntry createFolder({required String title, DateTime? now});

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
