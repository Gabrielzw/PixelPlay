import 'package:flutter/material.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../domain/entities/local_video.dart';
import 'album_video_preview.dart';

const double kSearchVideoTileRadius = 20;
const double kSearchVideoTilePadding = 14;
const double kSearchVideoTileGap = 14;
const double kSearchVideoTileSpacing = 12;
const double kSearchVideoTitleHeight = 1.1;
const double kSearchVideoMetaHeight = 1.15;
const String kUnknownVideoTitle = '未命名视频';
const String kUnknownResolutionLabel = '分辨率未知';
const String kUnknownModifiedTimeLabel = '修改时间未知';

class LocalLibrarySearchVideoTile extends StatelessWidget {
  final LocalVideo video;
  final String albumTitle;
  final VoidCallback onTap;

  const LocalLibrarySearchVideoTile({
    super.key,
    required this.video,
    required this.albumTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: const BorderRadius.all(Radius.circular(kSearchVideoTileRadius)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(kSearchVideoTileRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kSearchVideoTilePadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AlbumVideoPreview(
                durationText: formatVideoDuration(
                  Duration(milliseconds: video.durationMs),
                ),
                previewSeed: video.id,
                thumbnailRequest: VideoThumbnailRequest.tile(
                  videoId: video.id,
                  videoPath: video.path,
                  dateModified: video.dateModified,
                ),
              ),
              const SizedBox(width: kSearchVideoTileGap),
              Expanded(child: _SearchVideoMeta(video: video, albumTitle: albumTitle)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchVideoMeta extends StatelessWidget {
  final LocalVideo video;
  final String albumTitle;

  const _SearchVideoMeta({required this.video, required this.albumTitle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final title = video.title.trim().isEmpty ? kUnknownVideoTitle : video.title;

    return SizedBox(
      height: kVideoTilePreviewWidth / kVideoTilePreviewAspectRatio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: kSearchVideoTitleHeight,
            ),
          ),
          Text(
            '相册 · $albumTitle',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: secondaryColor,
              height: kSearchVideoMetaHeight,
            ),
          ),
          Text(
            '${_formatResolution(video)} · ${formatFileSize(video.size)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: secondaryColor,
              height: kSearchVideoMetaHeight,
            ),
          ),
          Text(
            _formatModifiedTime(video.dateModified),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: secondaryColor,
              height: kSearchVideoMetaHeight,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatResolution(LocalVideo video) {
  if (video.width <= 0 || video.height <= 0) {
    return kUnknownResolutionLabel;
  }
  return formatResolution(width: video.width, height: video.height);
}

String _formatModifiedTime(int modifiedSeconds) {
  if (modifiedSeconds <= 0) {
    return kUnknownModifiedTimeLabel;
  }
  return formatChineseDateTime(
    DateTime.fromMillisecondsSinceEpoch(
      modifiedSeconds * Duration.millisecondsPerSecond,
    ),
  );
}
