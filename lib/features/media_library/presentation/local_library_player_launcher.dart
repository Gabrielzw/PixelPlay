import 'package:flutter/material.dart';

import '../../../shared/utils/media_formatters.dart';
import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';
import '../domain/entities/local_video.dart';
import 'local_library_sort_type.dart';

const String kLocalLibraryUnknownVideoTitle = '未命名视频';

PlayerQueueItem buildLocalVideoPlayerItem(LocalVideo video) {
  final title = _resolveVideoTitle(video.title);

  return PlayerQueueItem(
    id: video.id.toString(),
    title: title,
    sourceLabel: resolveLocalLibraryAlbumTitle(video.bucketName),
    path: video.path,
    duration: Duration(milliseconds: video.durationMs),
    resolutionText: _resolveVideoResolutionText(video),
    previewAspectRatio: _resolvePreviewAspectRatio(video),
    lastKnownPositionMs: video.lastPlayPositionMs,
    localVideoId: video.id,
    localVideoDateModified: video.dateModified,
  );
}

Future<void> openLocalVideoPlayer({
  required BuildContext context,
  required LocalVideo video,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    buildPlayerPageRoute(
      child: PlayerPage(
        playlist: <PlayerQueueItem>[buildLocalVideoPlayerItem(video)],
      ),
    ),
  );
}

String resolveLocalVideoTitle(String title) {
  return _resolveVideoTitle(title);
}

String? resolveLocalVideoResolutionText(LocalVideo video) {
  return _resolveVideoResolutionText(video);
}

String _resolveVideoTitle(String title) {
  if (title.trim().isEmpty) {
    return kLocalLibraryUnknownVideoTitle;
  }
  return title;
}

String? _resolveVideoResolutionText(LocalVideo video) {
  if (video.width <= 0 || video.height <= 0) {
    return null;
  }
  return formatResolution(width: video.width, height: video.height);
}

double _resolvePreviewAspectRatio(LocalVideo video) {
  if (video.width <= 0 || video.height <= 0) {
    return kDefaultPreviewAspectRatio;
  }
  return video.width / video.height;
}
