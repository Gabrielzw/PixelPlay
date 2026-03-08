import 'package:flutter/material.dart';

import '../favorite_folder_sort_type.dart';

class FavoritesPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
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

  const FavoritesPageAppBar({
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (isSelectionMode) {
      return _buildSelectionAppBar();
    }
    return _buildDefaultAppBar(context);
  }

  AppBar _buildSelectionAppBar() {
    return AppBar(
      leading: IconButton(
        tooltip: '取消选择',
        onPressed: onExitSelectionMode,
        icon: const Icon(Icons.close),
      ),
      title: Text('已选择 $selectedCount 项'),
      actions: <Widget>[
        IconButton(
          tooltip: '删除',
          onPressed: onDeletePressed,
          icon: const Icon(Icons.delete_outline_rounded),
        ),
      ],
    );
  }

  AppBar _buildDefaultAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: isSearching
          ? TextField(
              controller: searchController,
              autofocus: true,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: '搜索收藏夹...',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            )
          : Text(
              '收藏夹',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
      actions: <Widget>[
        IconButton(
          tooltip: '添加收藏夹',
          onPressed: onAddPressed,
          icon: const Icon(Icons.create_new_folder_outlined),
        ),
        if (isSearching)
          IconButton(
            tooltip: '关闭搜索',
            onPressed: onStopSearching,
            icon: const Icon(Icons.close),
          )
        else
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
                  (FavoriteFolderSortType sortType) => _buildSortItem(
                    colorScheme: colorScheme,
                    sortType: sortType,
                  ),
                )
                .toList(growable: false);
          },
        ),
      ],
    );
  }

  PopupMenuItem<FavoriteFolderSortType> _buildSortItem({
    required ColorScheme colorScheme,
    required FavoriteFolderSortType sortType,
  }) {
    final isSelected = currentSort == sortType;

    return PopupMenuItem<FavoriteFolderSortType>(
      value: sortType,
      child: Row(
        children: <Widget>[
          Icon(
            sortType.icon,
            size: 20,
            color: isSelected ? colorScheme.primary : null,
          ),
          const SizedBox(width: 12),
          Text(
            sortType.label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? colorScheme.primary : null,
            ),
          ),
          if (isSelected) ...<Widget>[
            const Spacer(),
            Icon(Icons.check, size: 20, color: colorScheme.primary),
          ],
        ],
      ),
    );
  }
}
