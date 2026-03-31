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

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'durationText': durationText,
      'updatedAtMs': updatedAt.millisecondsSinceEpoch,
      'previewSeed': previewSeed,
      'sourceLabel': sourceLabel,
      'path': path,
      'sourceUri': sourceUri,
      'durationMs': durationMs,
      'sourceKindKey': sourceKind?.key,
      'resolutionText': resolutionText,
      'previewAspectRatio': previewAspectRatio,
      'lastKnownPositionMs': lastKnownPositionMs,
      'localVideoId': localVideoId,
      'localVideoDateModified': localVideoDateModified,
      'webDavAccountId': webDavAccountId,
      'thumbnailRequest': thumbnailRequest?.toJson(),
    };
  }

  factory FavoriteVideoEntry.fromJson(Map<String, Object?> json) {
    return FavoriteVideoEntry(
      id: json['id']! as String,
      title: json['title']! as String,
      durationText: json['durationText']! as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (json['updatedAtMs'] as num).toInt(),
      ),
      previewSeed: (json['previewSeed'] as num).toInt(),
      sourceLabel: json['sourceLabel'] as String?,
      path: json['path'] as String?,
      sourceUri: json['sourceUri'] as String?,
      durationMs: (json['durationMs'] as num?)?.toInt(),
      sourceKind: _sourceKindFromJson(json['sourceKindKey'] as String?),
      resolutionText: json['resolutionText'] as String?,
      previewAspectRatio: (json['previewAspectRatio'] as num?)?.toDouble(),
      lastKnownPositionMs: (json['lastKnownPositionMs'] as num?)?.toInt(),
      localVideoId: (json['localVideoId'] as num?)?.toInt(),
      localVideoDateModified: (json['localVideoDateModified'] as num?)?.toInt(),
      webDavAccountId: json['webDavAccountId'] as String?,
      thumbnailRequest: _thumbnailRequestFromJson(
        json['thumbnailRequest'] as Map<String, Object?>?,
      ),
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

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'createdAtMs': createdAt.millisecondsSinceEpoch,
      'videos': videos
          .map((FavoriteVideoEntry video) => video.toJson())
          .toList(growable: false),
    };
  }

  factory FavoriteFolderEntry.fromJson(Map<String, Object?> json) {
    final videosJson = (json['videos'] as List<Object?>?) ?? const <Object?>[];
    return FavoriteFolderEntry(
      id: json['id']! as String,
      title: json['title']! as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (json['createdAtMs'] as num).toInt(),
      ),
      videos: videosJson
          .map((Object? item) {
            return FavoriteVideoEntry.fromJson(
              Map<String, Object?>.from(item! as Map<Object?, Object?>),
            );
          })
          .toList(growable: false),
    );
  }
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

MediaSourceKind? _sourceKindFromJson(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return mediaSourceKindFromKey(value);
}

VideoThumbnailRequest? _thumbnailRequestFromJson(Map<String, Object?>? json) {
  if (json == null) {
    return null;
  }
  return VideoThumbnailRequest.fromJson(json);
}
