import 'package:flutter/material.dart';

import 'album_video_preview.dart';

const double kVideoTileRadius = 24;
const double kVideoTilePadding = 14;
const double kVideoTileGap = 16;
const double kVideoTileInfoHeight =
    kVideoTilePreviewWidth / kVideoTilePreviewAspectRatio;
const double kVideoTileMetaSpacing = 8;
const double kVideoTileShadowBlur = 18;
const double kVideoTileShadowOffsetY = 8;
const double kVideoTileShadowOpacity = 0.08;
const double kVideoTileTitleFontSize = 15;
const double kVideoTileMetaFontSize = 11.5;
const double kVideoTileTitleHeight = 1.15;
const double kVideoTileMetaHeight = 1.1;

const Color kTileLightBackground = Color(0xFFFFFFFF);

@immutable
class AlbumVideoTileData {
  final String title;
  final String durationText;
  final String resolutionText;
  final String sizeText;
  final String modifiedTimeText;
  final int previewSeed;

  const AlbumVideoTileData({
    required this.title,
    required this.durationText,
    required this.resolutionText,
    required this.sizeText,
    required this.modifiedTimeText,
    required this.previewSeed,
  });
}

class AlbumVideoTile extends StatelessWidget {
  final AlbumVideoTileData data;
  final VoidCallback onTap;

  const AlbumVideoTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerLow
        : kTileLightBackground;
    final shadowColor = Colors.black.withValues(alpha: kVideoTileShadowOpacity);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(kVideoTileRadius)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadowColor,
            blurRadius: kVideoTileShadowBlur,
            offset: const Offset(0, kVideoTileShadowOffsetY),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(kVideoTileRadius),
          ),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(kVideoTilePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AlbumVideoPreview(
                  durationText: data.durationText,
                  previewSeed: data.previewSeed,
                ),
                const SizedBox(width: kVideoTileGap),
                Expanded(
                  child: SizedBox(
                    height: kVideoTileInfoHeight,
                    child: _VideoTileInfo(data: data),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoTileInfo extends StatelessWidget {
  final AlbumVideoTileData data;

  const _VideoTileInfo({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.onSurfaceVariant;
    final titleStyle =
        theme.textTheme.titleMedium?.copyWith(
          fontSize: kVideoTileTitleFontSize,
          fontWeight: FontWeight.w700,
          height: kVideoTileTitleHeight,
        ) ??
        const TextStyle(
          fontSize: kVideoTileTitleFontSize,
          fontWeight: FontWeight.w700,
          height: kVideoTileTitleHeight,
        );
    final metaStyle =
        theme.textTheme.bodySmall?.copyWith(
          fontSize: kVideoTileMetaFontSize,
          color: secondaryColor,
          height: kVideoTileMetaHeight,
        ) ??
        TextStyle(
          fontSize: kVideoTileMetaFontSize,
          color: secondaryColor,
          height: kVideoTileMetaHeight,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          data.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${data.resolutionText}  ${data.sizeText}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: metaStyle,
            ),
            const SizedBox(height: kVideoTileMetaSpacing),
            Text(
              data.modifiedTimeText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: metaStyle,
            ),
          ],
        ),
      ],
    );
  }
}
