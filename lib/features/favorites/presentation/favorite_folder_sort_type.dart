import 'package:flutter/material.dart';

import 'favorite_models.dart';

enum FavoriteFolderSortType {
  updatedDesc,
  updatedAsc,
  countDesc,
  countAsc,
  nameAsc,
  nameDesc,
}

extension FavoriteFolderSortTypeX on FavoriteFolderSortType {
  String get label {
    return switch (this) {
      FavoriteFolderSortType.updatedDesc => '\u6700\u8fd1\u66f4\u65b0',
      FavoriteFolderSortType.updatedAsc => '\u6700\u65e9\u66f4\u65b0',
      FavoriteFolderSortType.countDesc => '\u89c6\u9891\u6700\u591a',
      FavoriteFolderSortType.countAsc => '\u89c6\u9891\u6700\u5c11',
      FavoriteFolderSortType.nameAsc => '\u540d\u79f0 A-Z',
      FavoriteFolderSortType.nameDesc => '\u540d\u79f0 Z-A',
    };
  }

  IconData get icon {
    return switch (this) {
      FavoriteFolderSortType.updatedDesc => Icons.schedule_rounded,
      FavoriteFolderSortType.updatedAsc => Icons.history_toggle_off_rounded,
      FavoriteFolderSortType.countDesc => Icons.video_collection_rounded,
      FavoriteFolderSortType.countAsc => Icons.video_collection_outlined,
      FavoriteFolderSortType.nameAsc => Icons.sort_by_alpha_rounded,
      FavoriteFolderSortType.nameDesc => Icons.sort_by_alpha_outlined,
    };
  }
}

List<FavoriteFolderEntry> sortFavoriteFolders(
  Iterable<FavoriteFolderEntry> folders,
  FavoriteFolderSortType sortType, {
  bool pinDefaultFolder = true,
}) {
  final sortedFolders = folders.toList(growable: false);
  sortedFolders.sort((FavoriteFolderEntry left, FavoriteFolderEntry right) {
    if (!pinDefaultFolder) {
      return _compareFavoriteFoldersBySort(left, right, sortType);
    }
    return compareFavoriteFoldersPinned(
      left: left,
      right: right,
      fallbackCompare: (left, right) {
        return _compareFavoriteFoldersBySort(left, right, sortType);
      },
    );
  });
  return List<FavoriteFolderEntry>.unmodifiable(sortedFolders);
}

int _compareFavoriteFoldersBySort(
  FavoriteFolderEntry left,
  FavoriteFolderEntry right,
  FavoriteFolderSortType sortType,
) {
  return switch (sortType) {
    FavoriteFolderSortType.updatedDesc => right.updatedAt.compareTo(
      left.updatedAt,
    ),
    FavoriteFolderSortType.updatedAsc => left.updatedAt.compareTo(
      right.updatedAt,
    ),
    FavoriteFolderSortType.countDesc => right.videoCount.compareTo(
      left.videoCount,
    ),
    FavoriteFolderSortType.countAsc => left.videoCount.compareTo(
      right.videoCount,
    ),
    FavoriteFolderSortType.nameAsc => left.title.compareTo(right.title),
    FavoriteFolderSortType.nameDesc => right.title.compareTo(left.title),
  };
}
