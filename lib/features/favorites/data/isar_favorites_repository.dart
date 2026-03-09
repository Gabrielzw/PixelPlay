import 'package:isar_community/isar.dart';

import '../../../shared/data/isar/schemas/favorite_folder_isar_model.dart';
import '../domain/favorites_repository.dart';
import '../presentation/favorite_models.dart';

class IsarFavoritesRepository implements FavoritesRepository {
  final Isar isar;

  IsarFavoritesRepository({required this.isar}) {
    _ensureDefaultFolder();
  }

  @override
  List<FavoriteFolderEntry> loadFolders() {
    return List<FavoriteFolderEntry>.unmodifiable(
      _loadStoredFolders().map(
        (FavoriteFolderIsarModel folder) => folder.toDomain(),
      ),
    );
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

    isar.writeTxnSync(() {
      isar.favoriteFolderIsarModels.putSync(
        FavoriteFolderIsarModel.fromDomain(folder),
      );
    });
    return folder;
  }

  @override
  void deleteFolders(Set<String> folderIds) {
    if (folderIds.isEmpty) {
      return;
    }

    isar.writeTxnSync(() {
      final folders = _findFoldersByIds(folderIds);
      for (final folder in folders) {
        isar.favoriteFolderIsarModels.deleteSync(folder.id);
      }
    });
  }

  @override
  void addVideoToFolders({
    required FavoriteVideoEntry video,
    required Set<String> folderIds,
  }) {
    if (folderIds.isEmpty) {
      return;
    }

    final videoModel = FavoriteVideoIsarModel.fromDomain(video);
    isar.writeTxnSync(() {
      final folders = _findFoldersByIds(folderIds);
      for (final folder in folders) {
        folder.videos = _mergeVideo(folder.videos, videoModel);
        isar.favoriteFolderIsarModels.putSync(folder);
      }
    });
  }

  List<FavoriteFolderIsarModel> _loadStoredFolders() {
    final folders = isar.favoriteFolderIsarModels.where().findAllSync();
    if (folders.isNotEmpty) {
      return folders;
    }

    _ensureDefaultFolder();
    return isar.favoriteFolderIsarModels.where().findAllSync();
  }

  List<FavoriteFolderIsarModel> _findFoldersByIds(Set<String> folderIds) {
    return isar.favoriteFolderIsarModels
        .where()
        .findAllSync()
        .where((folder) {
          return folderIds.contains(folder.folderId);
        })
        .toList(growable: false);
  }

  List<FavoriteVideoIsarModel> _mergeVideo(
    List<FavoriteVideoIsarModel> videos,
    FavoriteVideoIsarModel video,
  ) {
    final nextVideos = List<FavoriteVideoIsarModel>.of(videos);
    final existingIndex = nextVideos.indexWhere(
      (FavoriteVideoIsarModel item) => item.mediaId == video.mediaId,
    );
    if (existingIndex >= 0) {
      nextVideos[existingIndex] = video;
      return nextVideos;
    }

    return <FavoriteVideoIsarModel>[...nextVideos, video];
  }

  void _ensureDefaultFolder() {
    final hasDefaultFolder = isar.favoriteFolderIsarModels
        .filter()
        .folderIdEqualTo(kDefaultFavoriteFolderId)
        .findFirstSync();
    if (hasDefaultFolder != null) {
      return;
    }

    isar.writeTxnSync(() {
      isar.favoriteFolderIsarModels.putSync(
        FavoriteFolderIsarModel.fromDomain(
          buildInitialFavoriteFolders().single,
        ),
      );
    });
  }
}
