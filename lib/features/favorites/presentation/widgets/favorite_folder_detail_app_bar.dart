import 'package:flutter/material.dart';

import '../favorite_folder_video_sort_type.dart';

class FavoriteFolderDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isSearching;
  final bool isSelectionMode;
  final bool canSelectAll;
  final int selectedCount;
  final TextEditingController searchController;
  final FavoriteFolderVideoSortType currentSort;
  final VoidCallback onLeadingPressed;
  final VoidCallback onSelectAllPressed;
  final VoidCallback onDeletePressed;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onStartSearching;
  final VoidCallback onStopSearching;
  final ValueChanged<FavoriteFolderVideoSortType> onSortSelected;
  final VoidCallback onMorePressed;

  const FavoriteFolderDetailAppBar({
    super.key,
    required this.isSearching,
    required this.isSelectionMode,
    required this.canSelectAll,
    required this.selectedCount,
    required this.searchController,
    required this.currentSort,
    required this.onLeadingPressed,
    required this.onSelectAllPressed,
    required this.onDeletePressed,
    required this.onSearchChanged,
    required this.onStartSearching,
    required this.onStopSearching,
    required this.onSortSelected,
    required this.onMorePressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: IconButton(
        tooltip: isSelectionMode ? '\u53d6\u6d88\u9009\u62e9' : '\u8fd4\u56de',
        onPressed: onLeadingPressed,
        icon: Icon(
          isSelectionMode ? Icons.close : Icons.arrow_back_ios_new_rounded,
        ),
      ),
      title: _buildTitle(colorScheme),
      actions: isSelectionMode
          ? _buildSelectionActions()
          : _buildDefaultActions(colorScheme),
    );
  }

  Widget? _buildTitle(ColorScheme colorScheme) {
    if (isSelectionMode) {
      return Text('\u5df2\u9009\u62e9 $selectedCount \u9879');
    }
    if (!isSearching) {
      return null;
    }
    return TextField(
      controller: searchController,
      autofocus: true,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: '\u641c\u7d22\u6536\u85cf\u89c6\u9891...',
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        border: InputBorder.none,
      ),
      onChanged: onSearchChanged,
    );
  }

  List<Widget> _buildSelectionActions() {
    return <Widget>[
      IconButton(
        tooltip: '\u5168\u9009',
        onPressed: canSelectAll ? onSelectAllPressed : null,
        icon: const Icon(Icons.select_all),
      ),
      IconButton(
        tooltip: '\u5220\u9664',
        onPressed: onDeletePressed,
        icon: const Icon(Icons.delete_outline_rounded),
      ),
    ];
  }

  List<Widget> _buildDefaultActions(ColorScheme colorScheme) {
    return <Widget>[
      IconButton(
        tooltip: isSearching ? '\u5173\u95ed\u641c\u7d22' : '\u641c\u7d22',
        onPressed: isSearching ? onStopSearching : onStartSearching,
        icon: Icon(isSearching ? Icons.close : Icons.search_rounded),
      ),
      PopupMenuButton<FavoriteFolderVideoSortType>(
        tooltip: '\u6392\u5e8f',
        icon: const Icon(Icons.sort_rounded),
        onSelected: onSortSelected,
        itemBuilder: (BuildContext context) {
          return FavoriteFolderVideoSortType.values
              .map(
                (FavoriteFolderVideoSortType sortType) => _buildSortItem(
                  colorScheme: colorScheme,
                  sortType: sortType,
                ),
              )
              .toList(growable: false);
        },
      ),
      IconButton(
        tooltip: '\u66f4\u591a',
        onPressed: onMorePressed,
        icon: const Icon(Icons.more_vert_rounded),
      ),
    ];
  }

  PopupMenuItem<FavoriteFolderVideoSortType> _buildSortItem({
    required ColorScheme colorScheme,
    required FavoriteFolderVideoSortType sortType,
  }) {
    final isSelected = currentSort == sortType;
    return PopupMenuItem<FavoriteFolderVideoSortType>(
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
