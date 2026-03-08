import 'package:flutter/material.dart';

import '../domain/entities/local_video.dart';

enum AlbumVideoSortType { latest, oldest, nameAsc, nameDesc, sizeAsc, sizeDesc }

extension AlbumVideoSortTypePresentation on AlbumVideoSortType {
  String get label => switch (this) {
    AlbumVideoSortType.latest => '最新',
    AlbumVideoSortType.oldest => '最旧',
    AlbumVideoSortType.nameAsc => '名称 A-Z',
    AlbumVideoSortType.nameDesc => '名称 Z-A',
    AlbumVideoSortType.sizeAsc => '大小升序',
    AlbumVideoSortType.sizeDesc => '大小降序',
  };

  IconData get icon => switch (this) {
    AlbumVideoSortType.latest => Icons.schedule_rounded,
    AlbumVideoSortType.oldest => Icons.history_toggle_off_rounded,
    AlbumVideoSortType.nameAsc => Icons.sort_by_alpha_rounded,
    AlbumVideoSortType.nameDesc => Icons.sort_by_alpha_rounded,
    AlbumVideoSortType.sizeAsc => Icons.storage_rounded,
    AlbumVideoSortType.sizeDesc => Icons.storage_rounded,
  };
}

List<LocalVideo> sortAlbumVideos(
  Iterable<LocalVideo> videos,
  AlbumVideoSortType sortType,
) {
  final sortedVideos = videos.toList(growable: false);
  sortedVideos.sort((LocalVideo left, LocalVideo right) {
    return switch (sortType) {
      AlbumVideoSortType.latest => _compareVideoByDate(right, left),
      AlbumVideoSortType.oldest => _compareVideoByDate(left, right),
      AlbumVideoSortType.nameAsc => _compareVideoByName(left, right),
      AlbumVideoSortType.nameDesc => _compareVideoByName(right, left),
      AlbumVideoSortType.sizeAsc => _compareVideoBySize(left, right),
      AlbumVideoSortType.sizeDesc => _compareVideoBySize(right, left),
    };
  });
  return List<LocalVideo>.unmodifiable(sortedVideos);
}

int _compareVideoByDate(LocalVideo left, LocalVideo right) {
  final dateComparison = left.dateAdded.compareTo(right.dateAdded);
  if (dateComparison != 0) {
    return dateComparison;
  }
  return _compareVideoByName(left, right);
}

int _compareVideoByName(LocalVideo left, LocalVideo right) {
  final leftTitle = left.title.trim().toLowerCase();
  final rightTitle = right.title.trim().toLowerCase();
  final nameComparison = leftTitle.compareTo(rightTitle);
  if (nameComparison != 0) {
    return nameComparison;
  }
  return left.id.compareTo(right.id);
}

int _compareVideoBySize(LocalVideo left, LocalVideo right) {
  final sizeComparison = left.size.compareTo(right.size);
  if (sizeComparison != 0) {
    return sizeComparison;
  }
  return _compareVideoByName(left, right);
}
