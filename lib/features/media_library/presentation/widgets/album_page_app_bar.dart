import 'package:flutter/material.dart';

import '../album_video_sort_type.dart';

class AlbumPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isSearching;
  final TextEditingController searchController;
  final AlbumVideoSortType currentSort;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onStartSearching;
  final VoidCallback onStopSearching;
  final ValueChanged<AlbumVideoSortType> onSortSelected;

  const AlbumPageAppBar({
    super.key,
    required this.title,
    required this.isSearching,
    required this.searchController,
    required this.currentSort,
    required this.onSearchChanged,
    required this.onStartSearching,
    required this.onStopSearching,
    required this.onSortSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: isSearching
          ? TextField(
              controller: searchController,
              autofocus: true,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: '搜索视频...',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            )
          : Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
      actions: <Widget>[
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
        PopupMenuButton<AlbumVideoSortType>(
          tooltip: '排序',
          icon: const Icon(Icons.sort),
          onSelected: onSortSelected,
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<AlbumVideoSortType>>[
              _buildSortItem(
                colorScheme: colorScheme,
                currentSort: currentSort,
                sortType: AlbumVideoSortType.latest,
              ),
              _buildSortItem(
                colorScheme: colorScheme,
                currentSort: currentSort,
                sortType: AlbumVideoSortType.oldest,
              ),
              const PopupMenuDivider(),
              _buildSortItem(
                colorScheme: colorScheme,
                currentSort: currentSort,
                sortType: AlbumVideoSortType.nameAsc,
              ),
              _buildSortItem(
                colorScheme: colorScheme,
                currentSort: currentSort,
                sortType: AlbumVideoSortType.nameDesc,
              ),
              const PopupMenuDivider(),
              _buildSortItem(
                colorScheme: colorScheme,
                currentSort: currentSort,
                sortType: AlbumVideoSortType.sizeAsc,
              ),
              _buildSortItem(
                colorScheme: colorScheme,
                currentSort: currentSort,
                sortType: AlbumVideoSortType.sizeDesc,
              ),
            ];
          },
        ),
      ],
    );
  }

  PopupMenuItem<AlbumVideoSortType> _buildSortItem({
    required ColorScheme colorScheme,
    required AlbumVideoSortType currentSort,
    required AlbumVideoSortType sortType,
  }) {
    final isSelected = currentSort == sortType;
    return PopupMenuItem<AlbumVideoSortType>(
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
