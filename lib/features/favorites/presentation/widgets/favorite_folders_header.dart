import 'package:flutter/material.dart';

import '../favorite_folder_sort_type.dart';

const double kFavoriteFoldersHeaderPadding = 16;

class FavoriteFoldersHeader extends StatelessWidget {
  final bool isSearching;
  final bool isSelectionMode;
  final int selectedCount;
  final TextEditingController searchController;
  final FavoriteFolderSortType currentSort;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onStartSearching;
  final VoidCallback onStopSearching;
  final ValueChanged<FavoriteFolderSortType> onSortSelected;
  final VoidCallback onAddPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onExitSelectionMode;

  const FavoriteFoldersHeader({
    super.key,
    required this.isSearching,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.searchController,
    required this.currentSort,
    required this.onSearchChanged,
    required this.onStartSearching,
    required this.onStopSearching,
    required this.onSortSelected,
    required this.onAddPressed,
    required this.onDeletePressed,
    required this.onExitSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kFavoriteFoldersHeaderPadding,
        12,
        kFavoriteFoldersHeaderPadding,
        8,
      ),
      child: Column(
        children: <Widget>[
          if (isSelectionMode)
            _FavoriteFolderSelectionBar(
              selectedCount: selectedCount,
              onDeletePressed: onDeletePressed,
              onExitSelectionMode: onExitSelectionMode,
            )
          else
            _FavoriteFolderActionBar(
              currentSort: currentSort,
              onAddPressed: onAddPressed,
              onStartSearching: onStartSearching,
              onSortSelected: onSortSelected,
            ),
          if (isSearching && !isSelectionMode) ...<Widget>[
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: '搜索收藏夹或视频',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: '关闭搜索',
                  onPressed: onStopSearching,
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FavoriteFolderActionBar extends StatelessWidget {
  final FavoriteFolderSortType currentSort;
  final VoidCallback onAddPressed;
  final VoidCallback onStartSearching;
  final ValueChanged<FavoriteFolderSortType> onSortSelected;

  const _FavoriteFolderActionBar({
    required this.currentSort,
    required this.onAddPressed,
    required this.onStartSearching,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        Tooltip(
          message: '添加收藏夹',
          child: FilledButton.tonalIcon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.create_new_folder_outlined),
            label: const Text('添加收藏夹'),
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: '搜索',
          onPressed: onStartSearching,
          icon: const Icon(Icons.search),
        ),
        PopupMenuButton<FavoriteFolderSortType>(
          tooltip: '排序',
          icon: const Icon(Icons.sort_rounded),
          onSelected: onSortSelected,
          itemBuilder: (BuildContext context) {
            return FavoriteFolderSortType.values
                .map(
                  (FavoriteFolderSortType sortType) =>
                      PopupMenuItem<FavoriteFolderSortType>(
                        value: sortType,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              sortType.icon,
                              size: 20,
                              color: currentSort == sortType
                                  ? colorScheme.primary
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Text(sortType.label),
                          ],
                        ),
                      ),
                )
                .toList(growable: false);
          },
        ),
      ],
    );
  }
}

class _FavoriteFolderSelectionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDeletePressed;
  final VoidCallback onExitSelectionMode;

  const _FavoriteFolderSelectionBar({
    required this.selectedCount,
    required this.onDeletePressed,
    required this.onExitSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('已选择 $selectedCount 项'),
        const Spacer(),
        IconButton(
          tooltip: '删除',
          onPressed: onDeletePressed,
          icon: const Icon(Icons.delete_outline_rounded),
        ),
        TextButton(onPressed: onExitSelectionMode, child: const Text('取消')),
      ],
    );
  }
}
