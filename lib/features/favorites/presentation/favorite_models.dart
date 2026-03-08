import 'package:flutter/foundation.dart';

import '../../thumbnail_engine/domain/video_thumbnail_request.dart';

const String kDefaultFavoriteFolderId = 'default-favorites';
const String kDefaultFavoriteFolderTitle = '默认收藏夹';

@immutable
class FavoriteVideoEntry {
  final String id;
  final String title;
  final String durationText;
  final DateTime updatedAt;
  final int previewSeed;
  final VideoThumbnailRequest? thumbnailRequest;

  const FavoriteVideoEntry({
    required this.id,
    required this.title,
    required this.durationText,
    required this.updatedAt,
    required this.previewSeed,
    this.thumbnailRequest,
  });
}

@immutable
class FavoriteFolderEntry {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<FavoriteVideoEntry> videos;

  FavoriteFolderEntry({
    required this.id,
    required this.title,
    required this.createdAt,
    required List<FavoriteVideoEntry> videos,
  }) : videos = List<FavoriteVideoEntry>.unmodifiable(videos);

  int get videoCount => videos.length;

  FavoriteVideoEntry? get latestVideo {
    if (videos.isEmpty) {
      return null;
    }

    FavoriteVideoEntry latest = videos.first;
    for (final FavoriteVideoEntry video in videos.skip(1)) {
      if (video.updatedAt.isAfter(latest.updatedAt)) {
        latest = video;
      }
    }
    return latest;
  }

  DateTime get updatedAt => latestVideo?.updatedAt ?? createdAt;

  bool get isDefaultFolder => id == kDefaultFavoriteFolderId;
}

int compareFavoriteFoldersPinned({
  required FavoriteFolderEntry left,
  required FavoriteFolderEntry right,
  required int Function(FavoriteFolderEntry left, FavoriteFolderEntry right)
  fallbackCompare,
}) {
  final leftPinned = left.isDefaultFolder;
  final rightPinned = right.isDefaultFolder;
  if (leftPinned == rightPinned) {
    return fallbackCompare(left, right);
  }
  return leftPinned ? -1 : 1;
}

List<FavoriteFolderEntry> buildInitialFavoriteFolders() {
  return <FavoriteFolderEntry>[
    FavoriteFolderEntry(
      id: kDefaultFavoriteFolderId,
      title: kDefaultFavoriteFolderTitle,
      createdAt: DateTime(2026, 3, 8, 12),
      videos: const <FavoriteVideoEntry>[],
    ),
  ];
}
