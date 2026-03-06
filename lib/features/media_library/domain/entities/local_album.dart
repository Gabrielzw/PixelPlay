import 'package:flutter/foundation.dart';

@immutable
class LocalAlbum {
  final String bucketId;
  final String bucketName;
  final int videoCount;
  final int latestDateAddedSeconds;

  const LocalAlbum({
    required this.bucketId,
    required this.bucketName,
    required this.videoCount,
    required this.latestDateAddedSeconds,
  });
}

