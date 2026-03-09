import 'package:flutter/material.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../../favorites/presentation/widgets/favorite_folder_preview.dart';
import '../../../media_library/presentation/widgets/album_video_preview_tokens.dart';
import '../../../media_library/presentation/widgets/album_video_tile.dart';
import '../../../media_library/presentation/widgets/media_library_card_tokens.dart';
import '../playlist_source_models.dart';

const double _kSelectionBorderWidth = 1.5;
const double _kSelectionIconSize = 22;
const double _kSelectionInset = 12;
const double _kSelectedSurfaceOpacity = 0.2;
const double _kMetaSpacing = 8;
const double _kMetaGap = 10;
const double _kMetaIconSize = 16;
const double _kMetaLineHeight = 1.2;
const double _kTitleLineHeight = 1.15;

class PlaylistSourceCard extends StatelessWidget {
  final PlaylistSourceEntry entry;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PlaylistSourceCard({
    super.key,
    required this.entry,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: <Widget>[
        DecoratedBox(
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
              child: Padding(
                padding: const EdgeInsets.all(kAlbumVideoTilePadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _PlaylistSourcePreview(entry: entry),
                    const SizedBox(width: kAlbumVideoTileGap),
                    Expanded(child: _PlaylistSourceInfo(entry: entry)),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isSelectionMode)
          Positioned(
            top: _kSelectionInset,
            right: _kSelectionInset,
            child: _SelectionBadge(isSelected: isSelected),
          ),
      ],
    );
  }

  BoxDecoration _buildDecoration(ColorScheme colorScheme) {
    return buildMediaLibraryCardDecoration(kAlbumVideoTileRadius).copyWith(
      border: isSelected
          ? Border.all(
              color: colorScheme.primary,
              width: _kSelectionBorderWidth,
            )
          : null,
    );
  }

  Color _surfaceColor(ColorScheme colorScheme) {
    if (!isSelected) {
      return colorScheme.surface;
    }
    return Color.alphaBlend(
      colorScheme.primary.withValues(alpha: _kSelectedSurfaceOpacity),
      colorScheme.surface,
    );
  }
}

class _PlaylistSourcePreview extends StatelessWidget {
  final PlaylistSourceEntry entry;

  const _PlaylistSourcePreview({required this.entry});

  @override
  Widget build(BuildContext context) {
    return FavoriteFolderPreview(
      previewSeed: entry.previewSeed,
      thumbnailRequest: entry.thumbnailRequest,
    );
  }
}

class _PlaylistSourceInfo extends StatelessWidget {
  final PlaylistSourceEntry entry;

  const _PlaylistSourceInfo({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: kVideoTilePreviewWidth / kVideoTilePreviewAspectRatio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            entry.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: _kTitleLineHeight,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _MetaRow(
                icon: _primaryMetaIcon(entry),
                text: _primaryMetaText(entry),
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: _kMetaSpacing),
              _MetaRow(
                icon: _secondaryMetaIcon(entry),
                text: _secondaryMetaText(entry),
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MetaRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        Icon(icon, size: _kMetaIconSize, color: color),
        const SizedBox(width: _kMetaGap),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: color,
              height: _kMetaLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionBadge extends StatelessWidget {
  final bool isSelected;

  const _SelectionBadge({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Icon(
      isSelected
          ? Icons.check_circle_rounded
          : Icons.radio_button_unchecked_rounded,
      size: _kSelectionIconSize,
      color: isSelected ? colorScheme.primary : colorScheme.outline,
    );
  }
}

IconData _primaryMetaIcon(PlaylistSourceEntry entry) {
  return switch (entry.sourceKind) {
    PlaylistSourceKind.localAlbum => Icons.video_collection_outlined,
    PlaylistSourceKind.webDavDirectory => Icons.cloud_outlined,
  };
}

String _primaryMetaText(PlaylistSourceEntry entry) {
  return switch (entry.sourceKind) {
    PlaylistSourceKind.localAlbum => '${entry.localAlbumVideoCount ?? 0} 个视频',
    PlaylistSourceKind.webDavDirectory =>
      'WebDAV · ${entry.webDavAccountAlias ?? '未知账户'}',
  };
}

IconData _secondaryMetaIcon(PlaylistSourceEntry entry) {
  return switch (entry.sourceKind) {
    PlaylistSourceKind.localAlbum => Icons.schedule_rounded,
    PlaylistSourceKind.webDavDirectory => Icons.folder_open_rounded,
  };
}

String _secondaryMetaText(PlaylistSourceEntry entry) {
  return switch (entry.sourceKind) {
    PlaylistSourceKind.localAlbum => formatChineseDateTime(entry.createdAt),
    PlaylistSourceKind.webDavDirectory =>
      entry.webDavDirectoryPath ?? kPlaylistRootDirectoryLabel,
  };
}
