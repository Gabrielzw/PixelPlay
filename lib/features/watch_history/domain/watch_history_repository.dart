import 'package:flutter/foundation.dart';

import '../../../shared/domain/media_source_kind.dart';

@immutable
class WatchHistoryRecord {
  final String mediaId;
  final String title;
  final String sourceLabel;
  final int watchedAtMs;
  final int positionMs;
  final int durationMs;
  final MediaSourceKind sourceKind;
  final String? mediaPath;
  final String? sourceUri;
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
    MediaSourceKind? sourceKind,
    bool? isRemote,
    this.mediaPath,
    this.sourceUri,
    this.localVideoId,
    this.localVideoDateModified,
    this.webDavAccountId,
  }) : sourceKind =
           sourceKind ??
           (webDavAccountId != null
               ? MediaSourceKind.webDav
               : isRemote == true
               ? MediaSourceKind.other
               : MediaSourceKind.local);

  bool get isRemote => sourceKind != MediaSourceKind.local;

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
