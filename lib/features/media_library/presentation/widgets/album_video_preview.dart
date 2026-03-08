import 'package:flutter/material.dart';

import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../../thumbnail_engine/presentation/widgets/video_thumbnail_image.dart';
import 'album_video_preview_placeholder.dart';
import 'album_video_preview_tokens.dart';

export 'album_video_preview_tokens.dart'
    show kVideoTilePreviewAspectRatio, kVideoTilePreviewWidth;

class AlbumVideoPreview extends StatelessWidget {
  final String durationText;
  final double? progressRatio;
  final int previewSeed;
  final VideoThumbnailRequest? thumbnailRequest;

  const AlbumVideoPreview({
    super.key,
    required this.durationText,
    this.progressRatio,
    required this.previewSeed,
    this.thumbnailRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: kVideoTilePreviewWidth,
      child: AspectRatio(
        aspectRatio: kVideoTilePreviewAspectRatio,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(kVideoPreviewRadius),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: _buildPreview()),
              if (progressRatio != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    minHeight: kPlaybackProgressBarHeight,
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.primary.withValues(
                      alpha: kPlaybackProgressTrackOpacity,
                    ),
                  ),
                ),
              Positioned(
                right: kVideoTilePreviewInnerPadding,
                bottom: kVideoTilePreviewInnerPadding,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: kDurationBadgeOpacity,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(kDurationBadgeRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDurationBadgeHorizontalPadding,
                      vertical: kDurationBadgeVerticalPadding,
                    ),
                    child: Text(
                      durationText,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: kDurationBadgeFontSize,
                        fontWeight: FontWeight.w600,
                        height: kDurationBadgeLineHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    final placeholder = AlbumVideoPreviewPlaceholder(previewSeed: previewSeed);
    final request = thumbnailRequest;
    if (request == null) {
      return placeholder;
    }

    return VideoThumbnailImage(
      request: request,
      fit: BoxFit.cover,
      priority: 1,
      placeholder: placeholder,
    );
  }
}
