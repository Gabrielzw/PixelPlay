import 'package:flutter/material.dart';

import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../../thumbnail_engine/presentation/widgets/video_thumbnail_image.dart';
import 'album_video_preview_placeholder.dart';
import 'album_video_preview_tokens.dart';

export 'album_video_preview_tokens.dart'
    show kVideoTilePreviewAspectRatio, kVideoTilePreviewWidth;

class AlbumVideoPreview extends StatelessWidget {
  final String durationText;
  final int previewSeed;
  final VideoThumbnailRequest? thumbnailRequest;

  const AlbumVideoPreview({
    super.key,
    required this.durationText,
    required this.previewSeed,
    this.thumbnailRequest,
  });

  @override
  Widget build(BuildContext context) {
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
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
