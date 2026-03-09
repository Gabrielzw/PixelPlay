import 'package:flutter/foundation.dart';

import '../../../shared/domain/media_source_kind.dart';
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
  final String? sourceLabel;
  final String? path;
  final String? sourceUri;
  final int? durationMs;
  final MediaSourceKind? sourceKind;
  final String? resolutionText;
  final double? previewAspectRatio;
  final int? lastKnownPositionMs;
  final int? localVideoId;
  final int? localVideoDateModified;
  final String? webDavAccountId;
  final VideoThumbnailRequest? thumbnailRequest;

  const FavoriteVideoEntry({
    required this.id,
    required this.title,
    required this.durationText,
    required this.updatedAt,
    required this.previewSeed,
    this.sourceLabel,
    this.path,
    this.sourceUri,
    this.durationMs,
    this.sourceKind,
    this.resolutionText,
    this.previewAspectRatio,
    this.lastKnownPositionMs,
    this.localVideoId,
    this.localVideoDateModified,
    this.webDavAccountId,
    this.thumbnailRequest,
  });

  String? get playbackPath => path ?? thumbnailRequest?.videoPath;

  int? get resolvedLocalVideoId => localVideoId ?? thumbnailRequest?.videoId;

  int? get resolvedLocalVideoDateModified {
    return localVideoDateModified ?? thumbnailRequest?.dateModified;
  }

  MediaSourceKind get resolvedSourceKind {
    final value = sourceKind;
    if (value != null) {
      return value;
    }
    return mediaSourceKindFromKey(
      null,
      isRemote: sourceUri?.trim().isNotEmpty == true,
      webDavAccountId: webDavAccountId,
    );
  }
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

bool favoriteVideosReferToSameSource(
  FavoriteVideoEntry left,
  FavoriteVideoEntry right,
) {
  if (left.id == right.id) {
    return true;
  }

  final leftLocalVideoId = left.resolvedLocalVideoId;
  final rightLocalVideoId = right.resolvedLocalVideoId;
  if (leftLocalVideoId != null && leftLocalVideoId == rightLocalVideoId) {
    return true;
  }

  final leftPath = left.playbackPath;
  final rightPath = right.playbackPath;
  if (leftPath != null && leftPath == rightPath) {
    return true;
  }

  final leftSourceUri = left.sourceUri;
  final rightSourceUri = right.sourceUri;
  if (leftSourceUri != null && leftSourceUri == rightSourceUri) {
    return true;
  }

  return false;
}
