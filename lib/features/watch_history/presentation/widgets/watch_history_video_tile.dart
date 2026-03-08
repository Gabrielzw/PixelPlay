import 'package:flutter/material.dart';

import '../../../media_library/presentation/widgets/album_video_preview.dart';
import '../../../media_library/presentation/widgets/album_video_tile.dart';
import '../../../media_library/presentation/widgets/media_library_card_tokens.dart';
import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';

@immutable
class WatchHistoryVideoTileData {
  final String id;
  final String title;
  final String sourceText;
  final String watchedTimeText;
  final String durationText;
  final double? progressRatio;
  final int previewSeed;
  final VideoThumbnailRequest? thumbnailRequest;

  const WatchHistoryVideoTileData({
    required this.id,
    required this.title,
    required this.sourceText,
    required this.watchedTimeText,
    required this.durationText,
    required this.progressRatio,
    required this.previewSeed,
    required this.thumbnailRequest,
  });
}

class WatchHistoryVideoTile extends StatelessWidget {
  final WatchHistoryVideoTileData data;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const WatchHistoryVideoTile({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final decoration = buildMediaLibraryCardDecoration(kAlbumVideoTileRadius)
        .copyWith(
          border: selected
              ? Border.all(color: colorScheme.primary, width: 1.5)
              : null,
        );
    final backgroundColor = selected
        ? Color.alphaBlend(
            colorScheme.primary.withValues(alpha: 0.08),
            colorScheme.surface,
          )
        : colorScheme.surface;

    return Semantics(
      selected: selected,
      child: DecoratedBox(
        decoration: decoration,
        child: Material(
          color: backgroundColor,
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
                        durationText: data.durationText,
                        progressRatio: data.progressRatio,
                        previewSeed: data.previewSeed,
                        thumbnailRequest: data.thumbnailRequest,
                      ),
                      const SizedBox(width: kAlbumVideoTileGap),
                      Expanded(child: _WatchHistoryTileInfo(data: data)),
                    ],
                  ),
                ),
                if (selected)
                  PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: _SelectedBadge(colorScheme: colorScheme),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WatchHistoryTileInfo extends StatelessWidget {
  final WatchHistoryVideoTileData data;

  const _WatchHistoryTileInfo({required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return SizedBox(
      height: kVideoTilePreviewWidth / kVideoTilePreviewAspectRatio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 32,
            child: Text(
              data.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: kAlbumVideoTitleHeight,
              ),
            ),
          ),
          Text(
            data.sourceText,
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
              data.watchedTimeText,
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
        color: colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.check_circle, color: colorScheme.primary, size: 22),
    );
  }
}
