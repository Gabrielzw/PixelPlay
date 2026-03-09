import 'package:isar_community/isar.dart';

import '../../../../features/favorites/presentation/favorite_models.dart';
import '../../../../features/thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../../domain/media_source_kind.dart';

part 'favorite_folder_isar_model.g.dart';

@collection
class FavoriteFolderIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String folderId;

  late String title;
  late int createdAtMs;
  List<FavoriteVideoIsarModel> videos = <FavoriteVideoIsarModel>[];

  FavoriteFolderEntry toDomain() {
    return FavoriteFolderEntry(
      id: folderId,
      title: title,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      videos: videos
          .map((FavoriteVideoIsarModel video) => video.toDomain())
          .toList(growable: false),
    );
  }

  static FavoriteFolderIsarModel fromDomain(
    FavoriteFolderEntry folder, {
    Id? id,
  }) {
    return FavoriteFolderIsarModel()
      ..id = id ?? Isar.autoIncrement
      ..folderId = folder.id
      ..title = folder.title
      ..createdAtMs = folder.createdAt.millisecondsSinceEpoch
      ..videos = folder.videos
          .map(FavoriteVideoIsarModel.fromDomain)
          .toList(growable: false);
  }
}

@embedded
class FavoriteVideoIsarModel {
  late String mediaId;
  late String title;
  late String durationText;
  late int updatedAtMs;
  late int previewSeed;
  String? sourceLabel;
  String? path;
  String? sourceUri;
  int? durationMs;
  String? sourceKindKey;
  String? resolutionText;
  double? previewAspectRatio;
  int? lastKnownPositionMs;
  int? localVideoId;
  int? localVideoDateModified;
  String? webDavAccountId;
  FavoriteThumbnailRequestIsarModel? thumbnailRequest;

  FavoriteVideoEntry toDomain() {
    return FavoriteVideoEntry(
      id: mediaId,
      title: title,
      durationText: durationText,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      previewSeed: previewSeed,
      sourceLabel: sourceLabel,
      path: path,
      sourceUri: sourceUri,
      durationMs: durationMs,
      sourceKind: sourceKindKey == null
          ? null
          : mediaSourceKindFromKey(
              sourceKindKey,
              webDavAccountId: webDavAccountId,
            ),
      resolutionText: resolutionText,
      previewAspectRatio: previewAspectRatio,
      lastKnownPositionMs: lastKnownPositionMs,
      localVideoId: localVideoId,
      localVideoDateModified: localVideoDateModified,
      webDavAccountId: webDavAccountId,
      thumbnailRequest: thumbnailRequest?.toDomain(),
    );
  }

  static FavoriteVideoIsarModel fromDomain(FavoriteVideoEntry video) {
    return FavoriteVideoIsarModel()
      ..mediaId = video.id
      ..title = video.title
      ..durationText = video.durationText
      ..updatedAtMs = video.updatedAt.millisecondsSinceEpoch
      ..previewSeed = video.previewSeed
      ..sourceLabel = video.sourceLabel
      ..path = video.path
      ..sourceUri = video.sourceUri
      ..durationMs = video.durationMs
      ..sourceKindKey = video.sourceKind?.key
      ..resolutionText = video.resolutionText
      ..previewAspectRatio = video.previewAspectRatio
      ..lastKnownPositionMs = video.lastKnownPositionMs
      ..localVideoId = video.localVideoId
      ..localVideoDateModified = video.localVideoDateModified
      ..webDavAccountId = video.webDavAccountId
      ..thumbnailRequest = video.thumbnailRequest == null
          ? null
          : FavoriteThumbnailRequestIsarModel.fromDomain(
              video.thumbnailRequest!,
            );
  }
}

@embedded
class FavoriteThumbnailRequestIsarModel {
  late int videoId;
  late String videoPath;
  late int targetWidth;
  late int targetHeight;
  late int dateModified;

  VideoThumbnailRequest toDomain() {
    return VideoThumbnailRequest(
      cacheKey: '$videoId:$dateModified',
      videoId: videoId,
      videoPath: videoPath,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
      dateModified: dateModified,
    );
  }

  static FavoriteThumbnailRequestIsarModel fromDomain(
    VideoThumbnailRequest request,
  ) {
    return FavoriteThumbnailRequestIsarModel()
      ..videoId = request.videoId
      ..videoPath = request.videoPath
      ..targetWidth = request.targetWidth
      ..targetHeight = request.targetHeight
      ..dateModified = request.dateModified;
  }
}
