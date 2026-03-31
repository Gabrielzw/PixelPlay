import 'package:flutter/material.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../../media_library/presentation/widgets/album_video_preview.dart';
import '../../../media_library/presentation/widgets/album_video_tile.dart';
import '../../../media_library/presentation/widgets/media_library_card_tokens.dart';
import '../favorite_models.dart';

const String kUnknownFavoriteFolderVideoTitle = '未命名视频';
const double _kFavoriteVideoTileSelectionBorderWidth = 1.5;
const double _kFavoriteVideoTileSelectionIconSize = 22;
const double _kFavoriteVideoTileSelectionInset = 10;
const double _kFavoriteVideoTileSelectedSurfaceOpacity = 0.08;

class FavoriteFolderVideoTile extends StatelessWidget {
  final FavoriteVideoEntry video;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FavoriteFolderVideoTile({
    super.key,
    required this.video,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      child: DecoratedBox(
        decoration: _buildDecoration(colorScheme),
        child: Material(
          color: _surfaceColor(colorScheme),
          borderRadius: const BorderRadius.all(
            Radius.circular(kAlbumVideoTileRadius),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: const BorderRadius.all(
              Radius.circular(kAlbumVideoTileRadius),
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(kAlbumVideoTilePadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AlbumVideoPreview(
                        durationText: video.durationText,
                        previewSeed: video.previewSeed,
                        thumbnailRequest: video.thumbnailRequest,
                      ),
                      const SizedBox(width: kAlbumVideoTileGap),
                      Expanded(child: _FavoriteFolderVideoMeta(video: video)),
                    ],
                  ),
                ),
                if (selected)
                  PositionedDirectional(
                    top: _kFavoriteVideoTileSelectionInset,
                    end: _kFavoriteVideoTileSelectionInset,
                    child: _SelectedBadge(colorScheme: colorScheme),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(ColorScheme colorScheme) {
    return buildMediaLibraryCardDecoration(kAlbumVideoTileRadius).copyWith(
      border: selected
          ? Border.all(
              color: colorScheme.primary,
              width: _kFavoriteVideoTileSelectionBorderWidth,
            )
          : null,
    );
  }

  Color _surfaceColor(ColorScheme colorScheme) {
    if (!selected) {
      return colorScheme.surface;
    }

    return Color.alphaBlend(
      colorScheme.primary.withValues(
        alpha: _kFavoriteVideoTileSelectedSurfaceOpacity,
      ),
      colorScheme.surface,
    );
  }
}

class _FavoriteFolderVideoMeta extends StatelessWidget {
  final FavoriteVideoEntry video;

  const _FavoriteFolderVideoMeta({required this.video});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final title = video.title.trim().isEmpty
        ? kUnknownFavoriteFolderVideoTitle
        : video.title;

    return SizedBox(
      height: kVideoTilePreviewWidth / kVideoTilePreviewAspectRatio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 32,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: kAlbumVideoTitleHeight,
              ),
            ),
          ),
          Text(
            formatChineseDateTime(video.updatedAt),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: secondaryColor,
              height: kAlbumVideoInfoHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kAlbumVideoMetaSpacing),
            child: Text(
              video.durationText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: secondaryColor,
                height: kAlbumVideoInfoHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedBadge extends StatelessWidget {
  final ColorScheme colorScheme;

  const _SelectedBadge({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.check_rounded,
          size: _kFavoriteVideoTileSelectionIconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
