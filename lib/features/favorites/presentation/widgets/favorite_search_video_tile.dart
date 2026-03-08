import 'package:flutter/material.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../../media_library/presentation/widgets/album_video_preview.dart';
import '../favorite_models.dart';

const double kFavoriteSearchVideoTileRadius = 20;
const double kFavoriteSearchVideoTilePadding = 14;
const double kFavoriteSearchVideoTileGap = 14;
const double kFavoriteSearchVideoTileTitleHeight = 1.1;
const double kFavoriteSearchVideoTileMetaHeight = 1.15;
const String kUnknownFavoriteVideoTitle = '未命名视频';

class FavoriteSearchVideoTile extends StatelessWidget {
  final FavoriteVideoEntry video;
  final String folderTitle;
  final VoidCallback? onTap;

  const FavoriteSearchVideoTile({
    super.key,
    required this.video,
    required this.folderTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: const BorderRadius.all(
        Radius.circular(kFavoriteSearchVideoTileRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(kFavoriteSearchVideoTileRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kFavoriteSearchVideoTilePadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AlbumVideoPreview(
                durationText: video.durationText,
                previewSeed: video.previewSeed,
                thumbnailRequest: video.thumbnailRequest,
              ),
              const SizedBox(width: kFavoriteSearchVideoTileGap),
              Expanded(
                child: _FavoriteSearchVideoMeta(
                  video: video,
                  folderTitle: folderTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteSearchVideoMeta extends StatelessWidget {
  final FavoriteVideoEntry video;
  final String folderTitle;

  const _FavoriteSearchVideoMeta({
    required this.video,
    required this.folderTitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final title = video.title.trim().isEmpty
        ? kUnknownFavoriteVideoTitle
        : video.title;

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
              height: kFavoriteSearchVideoTileTitleHeight,
            ),
          ),
          Text(
            '收藏夹 · $folderTitle',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: secondaryColor,
              height: kFavoriteSearchVideoTileMetaHeight,
            ),
          ),
          Text(
            '更新时间 · ${formatChineseDateTime(video.updatedAt)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: secondaryColor,
              height: kFavoriteSearchVideoTileMetaHeight,
            ),
          ),
        ],
      ),
    );
  }
}
