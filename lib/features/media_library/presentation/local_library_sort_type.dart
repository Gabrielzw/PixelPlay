import 'package:flutter/material.dart';

import '../domain/entities/local_album.dart';
import '../domain/entities/local_video.dart';

const String kUnnamedAlbumLabel = '未命名相册';

enum LocalLibrarySortType { latest, oldest, nameAsc, nameDesc }

extension LocalLibrarySortTypePresentation on LocalLibrarySortType {
  String get label => switch (this) {
    LocalLibrarySortType.latest => '最新',
    LocalLibrarySortType.oldest => '最旧',
    LocalLibrarySortType.nameAsc => '名称 A-Z',
    LocalLibrarySortType.nameDesc => '名称 Z-A',
  };

  IconData get icon => switch (this) {
    LocalLibrarySortType.latest => Icons.schedule_rounded,
    LocalLibrarySortType.oldest => Icons.history_toggle_off_rounded,
    LocalLibrarySortType.nameAsc => Icons.sort_by_alpha_rounded,
    LocalLibrarySortType.nameDesc => Icons.sort_by_alpha_rounded,
  };
}

String resolveLocalLibraryAlbumTitle(String bucketName) {
  if (bucketName.trim().isEmpty) {
    return kUnnamedAlbumLabel;
  }
  return bucketName;
}

List<LocalAlbum> sortLocalAlbums(
  Iterable<LocalAlbum> albums,
  LocalLibrarySortType sortType,
) {
  final sortedAlbums = albums.toList(growable: false);
  sortedAlbums.sort((LocalAlbum left, LocalAlbum right) {
    return switch (sortType) {
      LocalLibrarySortType.latest => _compareAlbumByLatest(right, left),
      LocalLibrarySortType.oldest => _compareAlbumByLatest(left, right),
      LocalLibrarySortType.nameAsc => _compareAlbumByName(left, right),
      LocalLibrarySortType.nameDesc => _compareAlbumByName(right, left),
    };
  });
  return List<LocalAlbum>.unmodifiable(sortedAlbums);
}

List<LocalVideo> sortLocalVideos(
  Iterable<LocalVideo> videos,
  LocalLibrarySortType sortType,
) {
  final sortedVideos = videos.toList(growable: false);
  sortedVideos.sort((LocalVideo left, LocalVideo right) {
    return switch (sortType) {
      LocalLibrarySortType.latest => _compareVideoByDate(right, left),
      LocalLibrarySortType.oldest => _compareVideoByDate(left, right),
      LocalLibrarySortType.nameAsc => _compareVideoByName(left, right),
      LocalLibrarySortType.nameDesc => _compareVideoByName(right, left),
    };
  });
  return List<LocalVideo>.unmodifiable(sortedVideos);
}

int _compareAlbumByLatest(LocalAlbum left, LocalAlbum right) {
  final latestComparison = left.latestDateAddedSeconds.compareTo(
    right.latestDateAddedSeconds,
  );
  if (latestComparison != 0) {
    return latestComparison;
  }
  return _compareAlbumByName(left, right);
}

int _compareAlbumByName(LocalAlbum left, LocalAlbum right) {
  final leftTitle = resolveLocalLibraryAlbumTitle(left.bucketName).toLowerCase();
  final rightTitle = resolveLocalLibraryAlbumTitle(
    right.bucketName,
  ).toLowerCase();
  final nameComparison = leftTitle.compareTo(rightTitle);
  if (nameComparison != 0) {
    return nameComparison;
  }
  return left.bucketId.compareTo(right.bucketId);
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
