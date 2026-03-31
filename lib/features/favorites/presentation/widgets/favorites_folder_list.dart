import 'package:flutter/material.dart';

import '../favorite_models.dart';
import 'favorite_folder_card.dart';

const double _kFavoritesListPadding = 16;
const double _kFavoritesListSpacing = 10;
const double _kFavoritesEmptyIconSize = 42;

class FavoritesFolderList extends StatelessWidget {
  final List<FavoriteFolderEntry> folders;
  final Set<String> selectedFolderIds;
  final bool isSelectionMode;
  final ValueChanged<String> onFolderTap;
  final ValueChanged<String> onFolderLongPress;

  const FavoritesFolderList({
    super.key,
    required this.folders,
    required this.selectedFolderIds,
    required this.isSelectionMode,
    required this.onFolderTap,
    required this.onFolderLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) {
      return const _FavoritesEmptyState();
    }

    return ListView.separated(
      key: const PageStorageKey<String>('favorites_folder_list'),
      padding: const EdgeInsets.all(_kFavoritesListPadding),
      itemCount: folders.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: _kFavoritesListSpacing),
      itemBuilder: (BuildContext context, int index) {
        final folder = folders[index];
        return FavoriteFolderCard(
          data: FavoriteFolderCardData(
            id: folder.id,
            title: folder.title,
            videoCount: folder.videoCount,
            updatedAt: folder.updatedAt,
            previewSeed: folder.latestVideo?.previewSeed ?? 1,
            latestThumbnailRequest: folder.latestVideo?.thumbnailRequest,
          ),
          isSelectionMode: isSelectionMode,
          isSelected: selectedFolderIds.contains(folder.id),
          onTap: () => onFolderTap(folder.id),
          onLongPress: () => onFolderLongPress(folder.id),
        );
      },
    );
  }
}

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.folder_off_outlined,
            size: _kFavoritesEmptyIconSize,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            '还没有收藏夹',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
