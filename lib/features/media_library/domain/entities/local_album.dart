import 'package:flutter/foundation.dart';

@immutable
class LocalAlbum {
  final String bucketId;
  final String bucketName;
  final int videoCount;
  final int latestDateAddedSeconds;
  final int latestVideoId;
  final String latestVideoPath;
  final int latestVideoDateModified;

  const LocalAlbum({
    required this.bucketId,
    required this.bucketName,
    required this.videoCount,
    required this.latestDateAddedSeconds,
    required this.latestVideoId,
    required this.latestVideoPath,
    required this.latestVideoDateModified,
  });
}
