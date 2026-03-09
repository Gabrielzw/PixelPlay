import 'favorite_folder_video_sort_type.dart';
import 'favorite_models.dart';

List<FavoriteVideoEntry> buildVisibleFavoriteFolderVideos({
  required FavoriteFolderEntry folder,
  required FavoriteFolderVideoSortType sortType,
  required String searchQuery,
}) {
  final sortedVideos = sortFavoriteFolderVideos(folder.videos, sortType);
  final normalizedQuery = searchQuery.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return sortedVideos;
  }
  return List<FavoriteVideoEntry>.unmodifiable(
    sortedVideos.where(
      (FavoriteVideoEntry video) => _matchesFavoriteVideoQuery(
        video: video,
        normalizedQuery: normalizedQuery,
      ),
    ),
  );
}

FavoriteFolderEntry buildFavoriteFolderPlaybackEntry({
  required FavoriteFolderEntry folder,
  required FavoriteFolderVideoSortType sortType,
}) {
  return FavoriteFolderEntry(
    id: folder.id,
    title: folder.title,
    createdAt: folder.createdAt,
    videos: sortFavoriteFolderVideos(folder.videos, sortType),
  );
}

FavoriteFolderEntry buildFavoriteFolderWithoutVideoIds({
  required FavoriteFolderEntry folder,
  required Set<String> removedIds,
}) {
  return FavoriteFolderEntry(
    id: folder.id,
    title: folder.title,
    createdAt: folder.createdAt,
    videos: folder.videos
        .where((FavoriteVideoEntry video) => !removedIds.contains(video.id))
        .toList(growable: false),
  );
}

bool _matchesFavoriteVideoQuery({
  required FavoriteVideoEntry video,
  required String normalizedQuery,
}) {
  final searchTargets = <String>[
    video.title,
    video.sourceLabel ?? '',
    video.playbackPath ?? '',
    video.sourceUri ?? '',
  ];
  return searchTargets.any(
    (String value) => value.trim().toLowerCase().contains(normalizedQuery),
  );
}
