import 'package:flutter/foundation.dart';

@immutable
class PlaybackPositionRecord {
  final String mediaId;
  final int positionMs;
  final int durationMs;

  const PlaybackPositionRecord({
    required this.mediaId,
    required this.positionMs,
    required this.durationMs,
  });

  double get progressRatio {
    if (durationMs <= 0) {
      return 0;
    }
    return positionMs / durationMs;
  }
}

abstract interface class PlaybackPositionRepository {
  Future<PlaybackPositionRecord?> load(String mediaId);

  Future<void> save(PlaybackPositionRecord record);

  Future<void> clear(String mediaId);

  Future<void> clearAll();
}
