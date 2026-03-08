import 'package:flutter/material.dart';

import '../local_library_sort_type.dart';

class LocalLibraryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool isSearching;
  final TextEditingController searchController;
  final LocalLibrarySortType currentSort;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onStartSearching;
  final VoidCallback onStopSearching;
  final ValueChanged<LocalLibrarySortType> onSortSelected;
  final VoidCallback onOpenHistory;

  const LocalLibraryAppBar({
    super.key,
    required this.title,
    required this.isSearching,
    required this.searchController,
    required this.currentSort,
    required this.onSearchChanged,
    required this.onStartSearching,
    required this.onStopSearching,
    required this.onSortSelected,
    required this.onOpenHistory,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: isSearching
          ? TextField(
              controller: searchController,
              autofocus: true,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: '搜索相册或视频...',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            )
          : Text(title, style: titleStyle),
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
        PopupMenuButton<LocalLibrarySortType>(
          tooltip: '排序',
          icon: const Icon(Icons.sort),
          onSelected: onSortSelected,
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<LocalLibrarySortType>>[
                _buildSortItem(
                  colorScheme: colorScheme,
                  currentSort: currentSort,
                  sortType: LocalLibrarySortType.latest,
                ),
                _buildSortItem(
                  colorScheme: colorScheme,
                  currentSort: currentSort,
                  sortType: LocalLibrarySortType.oldest,
                ),
                const PopupMenuDivider(),
                _buildSortItem(
                  colorScheme: colorScheme,
                  currentSort: currentSort,
                  sortType: LocalLibrarySortType.nameAsc,
                ),
                _buildSortItem(
                  colorScheme: colorScheme,
                  currentSort: currentSort,
                  sortType: LocalLibrarySortType.nameDesc,
                ),
              ],
        ),
        IconButton(
          tooltip: '观看记录',
          onPressed: onOpenHistory,
          icon: const Icon(Icons.history_rounded),
        ),
      ],
    );
  }

  PopupMenuItem<LocalLibrarySortType> _buildSortItem({
    required ColorScheme colorScheme,
    required LocalLibrarySortType currentSort,
    required LocalLibrarySortType sortType,
  }) {
    final isSelected = currentSort == sortType;
    return PopupMenuItem<LocalLibrarySortType>(
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
