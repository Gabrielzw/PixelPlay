import 'package:flutter/material.dart';

const double kAlbumVideoTileHeight = 92;
const double kAlbumVideoTileRadius = 20;
const double kAlbumVideoTilePadding = 14;
const double kAlbumVideoTileGap = 14;
const double kAlbumVideoIconSize = 48;
const double kAlbumVideoMetaGap = 2;
const double kAlbumVideoTitleHeight = 1.1;
const double kAlbumVideoMetaHeight = 1.15;

@immutable
class AlbumVideoTileData {
  final String id;
  final String title;
  final String metaText;
  final String addedTimeText;

  const AlbumVideoTileData({
    required this.id,
    required this.title,
    required this.metaText,
    required this.addedTimeText,
  });
}

class AlbumVideoTile extends StatelessWidget {
  final AlbumVideoTileData data;
  final VoidCallback onTap;

  const AlbumVideoTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
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
            children: <Widget>[
              _AlbumVideoIcon(colorScheme: colorScheme),
              const SizedBox(width: kAlbumVideoTileGap),
              Expanded(child: _AlbumVideoInfo(data: data)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlbumVideoIcon extends StatelessWidget {
  final ColorScheme colorScheme;

  const _AlbumVideoIcon({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        width: kAlbumVideoIconSize,
        height: kAlbumVideoIconSize,
        child: Icon(
          Icons.play_arrow_rounded,
          color: colorScheme.onPrimaryContainer,
          size: 28,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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
        const SizedBox(height: kAlbumVideoMetaGap),
        Text(
          data.metaText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: secondaryColor,
            height: kAlbumVideoMetaHeight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          data.addedTimeText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: secondaryColor,
            height: kAlbumVideoMetaHeight,
          ),
        ),
      ],
    );
  }
}
