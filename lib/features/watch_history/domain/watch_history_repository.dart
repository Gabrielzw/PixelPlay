import 'package:flutter/foundation.dart';

@immutable
class WatchHistoryRecord {
  final String mediaId;
  final String title;
  final String sourceLabel;
  final int watchedAtMs;
  final int positionMs;
  final int durationMs;
  final bool isRemote;
  final String? mediaPath;
  final int? localVideoId;
  final int? localVideoDateModified;
  final String? webDavAccountId;

  const WatchHistoryRecord({
    required this.mediaId,
    required this.title,
    required this.sourceLabel,
    required this.watchedAtMs,
    required this.positionMs,
    required this.durationMs,
    required this.isRemote,
    this.mediaPath,
    this.localVideoId,
    this.localVideoDateModified,
    this.webDavAccountId,
  });

  double? get progressRatio {
    if (durationMs <= 0) {
      return null;
    }
    final clampedPosition = positionMs.clamp(0, durationMs).toDouble();
    return clampedPosition / durationMs;
  }
}

abstract interface class WatchHistoryRepository {
  Future<List<WatchHistoryRecord>> loadAll();

  Future<WatchHistoryRecord?> load(String mediaId);

  Future<void> save(WatchHistoryRecord record);

  Future<void> clearAll();
}
