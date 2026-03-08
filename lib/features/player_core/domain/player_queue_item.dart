import 'package:flutter/foundation.dart';

import '../../../shared/domain/media_source_kind.dart';

const double kDefaultPreviewAspectRatio = 16 / 9;

@immutable
class PlayerQueueItem {
  final String id;
  final String title;
  final String sourceLabel;
  final String? path;
  final String? sourceUri;
  final Duration duration;
  final MediaSourceKind sourceKind;
  final String? resolutionText;
  final double previewAspectRatio;
  final int? lastKnownPositionMs;
  final int? localVideoId;
  final int? localVideoDateModified;
  final String? webDavAccountId;
  final Map<String, String> httpHeaders;

  PlayerQueueItem({
    required this.id,
    required this.title,
    required this.sourceLabel,
    this.path,
    this.sourceUri,
    this.duration = Duration.zero,
    MediaSourceKind? sourceKind,
    bool? isRemote,
    this.resolutionText,
    this.previewAspectRatio = kDefaultPreviewAspectRatio,
    this.lastKnownPositionMs,
    this.localVideoId,
    this.localVideoDateModified,
    this.webDavAccountId,
    Map<String, String> httpHeaders = const <String, String>{},
  }) : sourceKind =
           sourceKind ??
           (webDavAccountId != null
               ? MediaSourceKind.webDav
               : isRemote == true
               ? MediaSourceKind.other
               : MediaSourceKind.local),
       httpHeaders = Map<String, String>.unmodifiable(httpHeaders);

  bool get hasKnownDuration => duration > Duration.zero;

  bool get isRemote => sourceKind != MediaSourceKind.local;

  String? get playbackUri => sourceUri ?? path;

  bool get hasPlayableSource {
    final value = playbackUri;
    return value != null && value.trim().isNotEmpty;
  }
}
