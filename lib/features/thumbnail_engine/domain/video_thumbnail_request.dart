import 'package:flutter/foundation.dart';

const int kAlbumCardThumbnailWidth = 512;
const int kAlbumCardThumbnailHeight = 328;
const int kAlbumVideoThumbnailWidth = 360;
const int kAlbumVideoThumbnailHeight = 254;

@immutable
class VideoThumbnailRequest {
  final String cacheKey;
  final int videoId;
  final String videoPath;
  final int targetWidth;
  final int targetHeight;
  final int dateModified;

  const VideoThumbnailRequest({
    required this.cacheKey,
    required this.videoId,
    required this.videoPath,
    required this.targetWidth,
    required this.targetHeight,
    required this.dateModified,
  });

  factory VideoThumbnailRequest.album({
    required int videoId,
    required String videoPath,
    required int dateModified,
  }) {
    return VideoThumbnailRequest(
      cacheKey: _buildCacheKey(
        videoId: videoId,
        dateModified: dateModified,
        targetWidth: kAlbumCardThumbnailWidth,
        targetHeight: kAlbumCardThumbnailHeight,
      ),
      videoId: videoId,
      videoPath: videoPath,
      targetWidth: kAlbumCardThumbnailWidth,
      targetHeight: kAlbumCardThumbnailHeight,
      dateModified: dateModified,
    );
  }

  factory VideoThumbnailRequest.tile({
    required int videoId,
    required String videoPath,
    required int dateModified,
  }) {
    return VideoThumbnailRequest(
      cacheKey: _buildCacheKey(
        videoId: videoId,
        dateModified: dateModified,
        targetWidth: kAlbumVideoThumbnailWidth,
        targetHeight: kAlbumVideoThumbnailHeight,
      ),
      videoId: videoId,
      videoPath: videoPath,
      targetWidth: kAlbumVideoThumbnailWidth,
      targetHeight: kAlbumVideoThumbnailHeight,
      dateModified: dateModified,
    );
  }
}

String _buildCacheKey({
  required int videoId,
  required int dateModified,
  required int targetWidth,
  required int targetHeight,
}) {
  return '$videoId:$dateModified';
}
