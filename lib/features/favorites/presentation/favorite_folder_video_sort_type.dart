import 'package:flutter/material.dart';

import 'favorite_models.dart';

enum FavoriteFolderVideoSortType {
  latest,
  oldest,
  nameAsc,
  nameDesc,
  durationAsc,
  durationDesc,
}

extension FavoriteFolderVideoSortTypeX on FavoriteFolderVideoSortType {
  String get label {
    return switch (this) {
      FavoriteFolderVideoSortType.latest => '\u6700\u8fd1\u6536\u85cf',
      FavoriteFolderVideoSortType.oldest => '\u6700\u65e9\u6536\u85cf',
      FavoriteFolderVideoSortType.nameAsc => '\u540d\u79f0 A-Z',
      FavoriteFolderVideoSortType.nameDesc => '\u540d\u79f0 Z-A',
      FavoriteFolderVideoSortType.durationAsc => '\u65f6\u957f\u5347\u5e8f',
      FavoriteFolderVideoSortType.durationDesc => '\u65f6\u957f\u964d\u5e8f',
    };
  }

  IconData get icon {
    return switch (this) {
      FavoriteFolderVideoSortType.latest => Icons.schedule_rounded,
      FavoriteFolderVideoSortType.oldest => Icons.history_toggle_off_rounded,
      FavoriteFolderVideoSortType.nameAsc => Icons.sort_by_alpha_rounded,
      FavoriteFolderVideoSortType.nameDesc => Icons.sort_by_alpha_outlined,
      FavoriteFolderVideoSortType.durationAsc => Icons.timer_outlined,
      FavoriteFolderVideoSortType.durationDesc => Icons.timer_rounded,
    };
  }
}

List<FavoriteVideoEntry> sortFavoriteFolderVideos(
  Iterable<FavoriteVideoEntry> videos,
  FavoriteFolderVideoSortType sortType,
) {
  final sortedVideos = videos.toList(growable: false);
  sortedVideos.sort((FavoriteVideoEntry left, FavoriteVideoEntry right) {
    return switch (sortType) {
      FavoriteFolderVideoSortType.latest => _compareVideoByUpdatedAt(
        right,
        left,
      ),
      FavoriteFolderVideoSortType.oldest => _compareVideoByUpdatedAt(
        left,
        right,
      ),
      FavoriteFolderVideoSortType.nameAsc => _compareVideoByName(left, right),
      FavoriteFolderVideoSortType.nameDesc => _compareVideoByName(right, left),
      FavoriteFolderVideoSortType.durationAsc => _compareVideoByDuration(
        left,
        right,
      ),
      FavoriteFolderVideoSortType.durationDesc => _compareVideoByDuration(
        right,
        left,
      ),
    };
  });
  return List<FavoriteVideoEntry>.unmodifiable(sortedVideos);
}

int _compareVideoByUpdatedAt(
  FavoriteVideoEntry left,
  FavoriteVideoEntry right,
) {
  final updatedComparison = left.updatedAt.compareTo(right.updatedAt);
  if (updatedComparison != 0) {
    return updatedComparison;
  }
  return _compareVideoByName(left, right);
}

int _compareVideoByName(FavoriteVideoEntry left, FavoriteVideoEntry right) {
  final leftTitle = left.title.trim().toLowerCase();
  final rightTitle = right.title.trim().toLowerCase();
  final titleComparison = leftTitle.compareTo(rightTitle);
  if (titleComparison != 0) {
    return titleComparison;
  }
  return left.id.compareTo(right.id);
}

int _compareVideoByDuration(FavoriteVideoEntry left, FavoriteVideoEntry right) {
  final durationComparison = _safeDurationMs(
    left,
  ).compareTo(_safeDurationMs(right));
  if (durationComparison != 0) {
    return durationComparison;
  }
  return _compareVideoByName(left, right);
}

int _safeDurationMs(FavoriteVideoEntry video) {
  final durationMs = video.durationMs ?? 0;
  if (durationMs < 0) {
    return 0;
  }
  return durationMs;
}
