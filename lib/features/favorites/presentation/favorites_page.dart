import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/page_navigation.dart';
import 'controllers/favorites_controller.dart';
import 'favorite_folder_detail_page.dart';
import 'favorite_folder_form_page.dart';
import 'favorite_folder_sort_type.dart';
import 'favorite_models.dart';
import 'favorite_search_video_launcher.dart';
import 'widgets/favorite_search_results.dart';
import 'widgets/favorites_confirm_dialog.dart';
import 'widgets/favorites_folder_list.dart';
import 'widgets/favorites_page_app_bar.dart';

class FavoritesPage extends StatefulWidget {
  final List<FavoriteFolderEntry>? initialFolders;
  final FavoritesController? favoritesController;

  const FavoritesPage({
    super.key,
    this.initialFolders,
    this.favoritesController,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final TextEditingController _searchController;
  List<FavoriteFolderEntry> _localFolders = const <FavoriteFolderEntry>[];
  FavoritesController? _favoritesController;
  Set<String> _selectedFolderIds = <String>{};
  String _searchQuery = '';
  bool _isSearching = false;
  bool _isCustomSort = false;
  FavoriteFolderSortType _currentSort = FavoriteFolderSortType.updatedDesc;

  bool get _isSelectionMode => _selectedFolderIds.isNotEmpty;
  bool get _showsSearchResults => _searchQuery.trim().isNotEmpty;
  bool get _usesSharedFavorites => widget.initialFolders == null;

  List<FavoriteFolderEntry> get _folders {
    if (_usesSharedFavorites) {
      return _favoritesController!.folders.toList(growable: false);
    }
    return _localFolders;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (_usesSharedFavorites) {
      _favoritesController =
          widget.favoritesController ?? Get.find<FavoritesController>();
      return;
    }
    _localFolders = List<FavoriteFolderEntry>.of(widget.initialFolders!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_usesSharedFavorites) {
      return Obx(_buildScaffold);
    }
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: FavoritesPageAppBar(
        isSearching: _isSearching,
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedFolderIds.length,
        searchController: _searchController,
        currentSort: _currentSort,
        onSearchChanged: _onSearchChanged,
        onStartSearching: _startSearching,
        onStopSearching: _stopSearching,
        onSortSelected: _onSortSelected,
        onAddPressed: _openCreateFolderPage,
        onDeletePressed: _deleteSelectedFolders,
        onExitSelectionMode: _clearSelection,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_showsSearchResults) {
      return FavoriteSearchResults(
        query: _searchQuery,
        folders: _folders,
        selectedFolderIds: _selectedFolderIds,
        isSelectionMode: _isSelectionMode,
        sortType: _currentSort,
        onFolderTap: _handleFolderTap,
        onFolderLongPress: _toggleSelection,
        onVideoTap: buildFavoriteSearchVideoTapHandler(context),
      );
    }

    return FavoritesFolderList(
      folders: _buildSortedFolders(),
      selectedFolderIds: _selectedFolderIds,
      isSelectionMode: _isSelectionMode,
      onFolderTap: _handleFolderTap,
      onFolderLongPress: _toggleSelection,
    );
  }

  List<FavoriteFolderEntry> _buildSortedFolders() {
    return sortFavoriteFolders(
      _folders,
      _currentSort,
      pinDefaultFolder: !_isCustomSort,
    );
  }

  Future<void> _openCreateFolderPage() async {
    final createdTitle = await pushRootPage<String>(
      context,
      (_) => FavoriteFolderFormPage(existingTitles: _existingTitles),
    );
    if (!mounted || createdTitle == null) {
      return;
    }
    _addFolder(createdTitle);
  }

  Set<String> get _existingTitles {
    return _folders
        .map(
          (FavoriteFolderEntry folder) =>
              normalizeFavoriteFolderTitle(folder.title),
        )
        .toSet();
  }

  void _addFolder(String title) {
    if (_usesSharedFavorites) {
      _favoritesController!.createFolder(title: title);
      return;
    }

    final now = DateTime.now();
    final nextFolder = FavoriteFolderEntry(
      id: _buildFolderId(now),
      title: title.trim(),
      createdAt: now,
      videos: const <FavoriteVideoEntry>[],
    );
    setState(() {
      _localFolders = <FavoriteFolderEntry>[..._folders, nextFolder];
    });
  }

  void _startSearching() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onSortSelected(FavoriteFolderSortType value) {
    setState(() {
      _currentSort = value;
      _isCustomSort = value != FavoriteFolderSortType.updatedDesc;
    });
  }

  void _handleFolderTap(String folderId) {
    if (_isSelectionMode) {
      _toggleSelection(folderId);
      return;
    }

    final folder = _findFolderById(folderId);
    if (folder == null) {
      return;
    }

    pushRootPage<void>(
      context,
      (_) => FavoriteFolderDetailPage(
        folder: folder,
        favoritesController: _favoritesController,
      ),
    );
  }

  void _toggleSelection(String folderId) {
    final folder = _findFolderById(folderId);
    if (folder == null || folder.isDefaultFolder) {
      return;
    }

    final nextSelectedFolderIds = Set<String>.of(_selectedFolderIds);
    final isAdded = nextSelectedFolderIds.add(folderId);
    if (!isAdded) {
      nextSelectedFolderIds.remove(folderId);
    }
    setState(() {
      _selectedFolderIds = nextSelectedFolderIds;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedFolderIds = <String>{};
    });
  }

  void _deleteSelectedFolders() {
    if (_selectedFolderIds.isEmpty) {
      return;
    }

    final selectedIds = _selectedFolderIds.where((String folderId) {
      final folder = _findFolderById(folderId);
      return folder != null && !folder.isDefaultFolder;
    }).toSet();
    if (selectedIds.isEmpty) {
      _clearSelection();
      return;
    }

    showFavoritesConfirmationDialog(
      context,
      title: '\u5220\u9664\u6536\u85cf\u5939',
      content:
          '\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684 ${selectedIds.length} \u4e2a\u6536\u85cf\u5939\u5417\uff1f',
      confirmLabel: '\u5220\u9664',
    ).then((bool confirmed) {
      if (!mounted || !confirmed) {
        return;
      }
      if (_usesSharedFavorites) {
        _favoritesController!.deleteFolders(selectedIds);
        setState(() {
          _selectedFolderIds = <String>{};
        });
        return;
      }

      setState(() {
        _localFolders = _folders
            .where(
              (FavoriteFolderEntry folder) => !selectedIds.contains(folder.id),
            )
            .toList(growable: false);
        _selectedFolderIds = <String>{};
      });
    });
  }

  FavoriteFolderEntry? _findFolderById(String folderId) {
    for (final folder in _folders) {
      if (folder.id == folderId) {
        return folder;
      }
    }
    return null;
  }
}

String _buildFolderId(DateTime now) {
  return 'favorite-folder-${now.microsecondsSinceEpoch}';
}
