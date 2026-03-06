import 'package:flutter/foundation.dart';

const double kDefaultPreviewAspectRatio = 16 / 9;

@immutable
class PlayerQueueItem {
  final String id;
  final String title;
  final String sourceLabel;
  final String? path;
  final Duration duration;
  final bool isRemote;
  final String? resolutionText;
  final double previewAspectRatio;
  final int? lastKnownPositionMs;

  const PlayerQueueItem({
    required this.id,
    required this.title,
    required this.sourceLabel,
    this.path,
    this.duration = Duration.zero,
    this.isRemote = false,
    this.resolutionText,
    this.previewAspectRatio = kDefaultPreviewAspectRatio,
    this.lastKnownPositionMs,
  });

  bool get hasKnownDuration => duration > Duration.zero;
}
