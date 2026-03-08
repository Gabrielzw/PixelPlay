import 'package:flutter/material.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../../media_library/presentation/widgets/album_video_preview_tokens.dart';
import '../../../media_library/presentation/widgets/album_video_tile.dart';
import '../../../media_library/presentation/widgets/media_library_card_tokens.dart';
import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import 'favorite_folder_preview.dart';

const double _kFolderCardSelectionBorderWidth = 1.5;
const double _kFolderCardSelectionIconSize = 22;
const double _kFolderCardSelectionInset = 12;
const double _kFolderCardSelectedSurfaceOpacity = 0.2;
const double _kFolderCardMetaSpacing = 8;
const double _kFolderCardMetaGap = 10;
const double _kFolderCardMetaIconSize = 16;
const double _kFolderCardMetaLineHeight = 1.2;
const double _kFolderCardTitleLineHeight = 1.15;

@immutable
class FavoriteFolderCardData {
  final String id;
  final String title;
  final int videoCount;
  final DateTime? updatedAt;
  final int previewSeed;
  final VideoThumbnailRequest? latestThumbnailRequest;

  const FavoriteFolderCardData({
    required this.id,
    required this.title,
    required this.videoCount,
    required this.updatedAt,
    required this.previewSeed,
    this.latestThumbnailRequest,
  });

  String get updatedAtText {
    final value = updatedAt;
    if (value == null) {
      return '未更新';
    }
    return formatChineseDateTime(value);
  }
}

class FavoriteFolderCard extends StatelessWidget {
  final FavoriteFolderCardData data;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FavoriteFolderCard({
    super.key,
    required this.data,
    required this.isSelectionMode,
    required this.isSelected,
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
                    FavoriteFolderPreview(
                      previewSeed: data.previewSeed,
                      thumbnailRequest: data.latestThumbnailRequest,
                    ),
                    const SizedBox(width: kAlbumVideoTileGap),
                    Expanded(
                      child: _FavoriteFolderInfo(
                        title: data.title,
                        videoCount: data.videoCount,
                        updatedAtText: data.updatedAtText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isSelectionMode)
          Positioned(
            top: _kFolderCardSelectionInset,
            right: _kFolderCardSelectionInset,
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
              width: _kFolderCardSelectionBorderWidth,
            )
          : null,
    );
  }

  Color _surfaceColor(ColorScheme colorScheme) {
    if (!isSelected) {
      return colorScheme.surface;
    }
    return Color.alphaBlend(
      colorScheme.primary.withValues(alpha: _kFolderCardSelectedSurfaceOpacity),
      colorScheme.surface,
    );
  }
}

class _FavoriteFolderInfo extends StatelessWidget {
  final String title;
  final int videoCount;
  final String updatedAtText;

  const _FavoriteFolderInfo({
    required this.title,
    required this.videoCount,
    required this.updatedAtText,
  });

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
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: _kFolderCardTitleLineHeight,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _MetaRow(
                icon: Icons.video_collection_outlined,
                text: '$videoCount 个视频',
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: _kFolderCardMetaSpacing),
              _MetaRow(
                icon: Icons.schedule_rounded,
                text: updatedAtText,
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
        Icon(icon, size: _kFolderCardMetaIconSize, color: color),
        const SizedBox(width: _kFolderCardMetaGap),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: color,
              height: _kFolderCardMetaLineHeight,
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
      size: _kFolderCardSelectionIconSize,
      color: isSelected ? colorScheme.primary : colorScheme.outline,
    );
  }
}
