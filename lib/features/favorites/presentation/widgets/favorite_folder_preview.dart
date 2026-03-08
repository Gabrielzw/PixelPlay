import 'package:flutter/material.dart';

import '../../../media_library/presentation/widgets/album_video_preview_placeholder.dart';
import '../../../media_library/presentation/widgets/album_video_preview_tokens.dart';
import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../../thumbnail_engine/presentation/widgets/video_thumbnail_image.dart';

class FavoriteFolderPreview extends StatelessWidget {
  final int previewSeed;
  final VideoThumbnailRequest? thumbnailRequest;

  const FavoriteFolderPreview({
    super.key,
    required this.previewSeed,
    required this.thumbnailRequest,
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
          child: _buildPreview(),
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
