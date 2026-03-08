import 'package:flutter/material.dart';

import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import 'album_video_preview.dart';
import 'media_library_card_tokens.dart';

const double kAlbumVideoTileHeight = 118;
const double kAlbumVideoTileRadius = 20;
const double kAlbumVideoTilePadding = 14;
const double kAlbumVideoTileGap = 14;
const double kAlbumVideoMetaSpacing = 6;
const double kAlbumVideoTitleHeight = 1.1;
const double kAlbumVideoInfoHeight = 1.15;

@immutable
class AlbumVideoTileData {
  final String id;
  final String title;
  final String durationText;
  final String resolutionText;
  final String sizeText;
  final String modifiedTimeText;
  final int previewSeed;
  final VideoThumbnailRequest thumbnailRequest;

  const AlbumVideoTileData({
    required this.id,
    required this.title,
    required this.durationText,
    required this.resolutionText,
    required this.sizeText,
    required this.modifiedTimeText,
    required this.previewSeed,
    required this.thumbnailRequest,
  });
}

class AlbumVideoTile extends StatelessWidget {
  final AlbumVideoTileData data;
  final VoidCallback onTap;

  const AlbumVideoTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: buildMediaLibraryCardDecoration(kAlbumVideoTileRadius),
      child: Material(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(kAlbumVideoTileRadius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(
            Radius.circular(kAlbumVideoTileRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kAlbumVideoTilePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AlbumVideoPreview(
                  durationText: data.durationText,
                  previewSeed: data.previewSeed,
                  thumbnailRequest: data.thumbnailRequest,
                ),
                const SizedBox(width: kAlbumVideoTileGap),
                Expanded(child: _AlbumVideoInfo(data: data)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlbumVideoInfo extends StatelessWidget {
  final AlbumVideoTileData data;

  const _AlbumVideoInfo({required this.data});

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
          const SizedBox(height: 2),
          Text(
            '${data.resolutionText} · ${data.sizeText}',
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
              data.modifiedTimeText,
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
