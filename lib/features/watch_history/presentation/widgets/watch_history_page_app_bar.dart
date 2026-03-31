import 'package:flutter/material.dart';

import 'watch_history_records_view.dart';

class WatchHistoryPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController tabController;
  final bool isSearching;
  final bool isSelectionMode;
  final bool canSelectAllInCurrentTab;
  final int selectedCount;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onStartSearching;
  final VoidCallback onStopSearching;
  final VoidCallback onSelectAllInCurrentTab;
  final VoidCallback onRemoveSelected;
  final VoidCallback onClearAllRequested;

  const WatchHistoryPageAppBar({
    super.key,
    required this.tabController,
    required this.isSearching,
    required this.isSelectionMode,
    required this.canSelectAllInCurrentTab,
    required this.selectedCount,
    required this.searchController,
    required this.onSearchChanged,
    required this.onStartSearching,
    required this.onStopSearching,
    required this.onSelectAllInCurrentTab,
    required this.onRemoveSelected,
    required this.onClearAllRequested,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(context),
      bottom: TabBar(
        controller: tabController,
        isScrollable: true,
        tabs: WatchHistoryFilter.values
            .map((WatchHistoryFilter filter) => Tab(text: filter.label))
            .toList(growable: false),
      ),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (isSelectionMode) {
      return Text('已选择 $selectedCount 项');
    }
    if (isSearching) {
      final colorScheme = Theme.of(context).colorScheme;
      return TextField(
        controller: searchController,
        autofocus: true,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: '搜索观看记录...',
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          border: InputBorder.none,
        ),
        onChanged: onSearchChanged,
      );
    }
    return const Text('观看记录');
  }

  List<Widget> _buildActions(BuildContext context) {
    if (isSelectionMode) {
      return <Widget>[
        IconButton(
          tooltip: '全选当前选项卡',
          onPressed: canSelectAllInCurrentTab ? onSelectAllInCurrentTab : null,
          icon: const Icon(Icons.select_all),
        ),
        IconButton(
          tooltip: '移除所选',
          onPressed: onRemoveSelected,
          icon: const Icon(Icons.delete_outline),
        ),
      ];
    }

    return <Widget>[
      IconButton(
        tooltip: isSearching ? '关闭搜索' : '搜索',
        onPressed: isSearching ? onStopSearching : onStartSearching,
        icon: Icon(isSearching ? Icons.close : Icons.search),
      ),
      PopupMenuButton<_WatchHistoryMenuAction>(
        tooltip: '选项',
        icon: const Icon(Icons.more_vert),
        onSelected: (_WatchHistoryMenuAction action) {
          switch (action) {
            case _WatchHistoryMenuAction.clearAll:
              onClearAllRequested();
          }
        },
        itemBuilder: (BuildContext context) {
          return const <PopupMenuEntry<_WatchHistoryMenuAction>>[
            PopupMenuItem<_WatchHistoryMenuAction>(
              value: _WatchHistoryMenuAction.clearAll,
              child: Text('清空观看记录'),
            ),
          ];
        },
      ),
    ];
  }
}

enum _WatchHistoryMenuAction { clearAll }
