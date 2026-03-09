import 'package:flutter/material.dart';

import '../../../media_library/presentation/widgets/album_video_preview.dart';
import '../favorite_models.dart';
import 'favorite_folder_preview.dart';

const double _kFavoriteFolderDetailHeaderGap = 16;
const double _kFavoriteFolderDetailCountLineHeight = 1.2;

class FavoriteFolderDetailHeader extends StatelessWidget {
  final FavoriteFolderEntry folder;

  const FavoriteFolderDetailHeader({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final latestVideo = folder.latestVideo;
    final secondaryColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FavoriteFolderPreview(
          previewSeed: latestVideo?.previewSeed ?? 1,
          thumbnailRequest: latestVideo?.thumbnailRequest,
          heroTag: buildFavoriteFolderPreviewHeroTag(folder.id),
        ),
        const SizedBox(width: _kFavoriteFolderDetailHeaderGap),
        Expanded(
          child: SizedBox(
            height: kVideoTilePreviewWidth / kVideoTilePreviewAspectRatio,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  folder.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${folder.videoCount} \u4e2a\u89c6\u9891',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: secondaryColor,
                    height: _kFavoriteFolderDetailCountLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
