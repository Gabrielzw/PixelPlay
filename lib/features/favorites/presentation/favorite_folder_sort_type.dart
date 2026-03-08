import 'package:flutter/material.dart';

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
      FavoriteFolderSortType.updatedDesc => '最近更新',
      FavoriteFolderSortType.updatedAsc => '最早更新',
      FavoriteFolderSortType.countDesc => '视频最多',
      FavoriteFolderSortType.countAsc => '视频最少',
      FavoriteFolderSortType.nameAsc => '名称 A-Z',
      FavoriteFolderSortType.nameDesc => '名称 Z-A',
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
