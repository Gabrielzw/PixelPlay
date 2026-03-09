import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import 'controllers/favorites_controller.dart';
import 'favorite_folder_detail_utils.dart';
import 'favorite_folder_player_launcher.dart';
import 'favorite_folder_video_sort_type.dart';
import 'favorite_models.dart';
import 'widgets/favorite_folder_detail_app_bar.dart';
import 'widgets/favorite_folder_detail_empty_view.dart';
import 'widgets/favorite_folder_detail_header.dart';
import 'widgets/favorite_folder_video_tile.dart';
import 'widgets/favorites_confirm_dialog.dart';

const EdgeInsets _kFavoriteFolderDetailPadding = EdgeInsets.fromLTRB(
  16,
  12,
  16,
  20,
);
const double _kFavoriteFolderDetailHeaderBottom = 20;
const double _kFavoriteFolderDetailVideoSpacing = 12;

class FavoriteFolderDetailPage extends StatefulWidget {
  final FavoriteFolderEntry folder;
  final FavoritesController? favoritesController;
  final WebDavAccountRepository? webDavAccountRepository;

  const FavoriteFolderDetailPage({
    super.key,
    required this.folder,
    this.favoritesController,
    this.webDavAccountRepository,
  });

  @override
  State<FavoriteFolderDetailPage> createState() =>
      _FavoriteFolderDetailPageState();
}

class _FavoriteFolderDetailPageState extends State<FavoriteFolderDetailPage> {
  late final TextEditingController _searchController;
  late FavoriteFolderEntry _folder;
  Set<String> _selectedVideoIds = <String>{};
  String _searchQuery = '';
  bool _isSearching = false;
  FavoriteFolderVideoSortType _sortType = FavoriteFolderVideoSortType.latest;

  bool get _isSelectionMode => _selectedVideoIds.isNotEmpty;

  FavoritesController? get _favoritesController {
    final controller = widget.favoritesController;
    if (controller != null) {
      return controller;
    }
    if (Get.isRegistered<FavoritesController>()) {
      return Get.find<FavoritesController>();
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _folder = widget.folder;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FavoriteFolderDetailAppBar(
        isSearching: _isSearching,
        isSelectionMode: _isSelectionMode,
        canSelectAll: _canSelectAllVisibleVideos(),
        selectedCount: _selectedVideoIds.length,
        searchController: _searchController,
        currentSort: _sortType,
        onLeadingPressed: _handleLeadingPressed,
        onSelectAllPressed: _selectAllVisibleVideos,
        onDeletePressed: () => unawaited(_deleteSelectedVideos()),
        onSearchChanged: _updateSearchQuery,
        onStartSearching: _startSearching,
        onStopSearching: _stopSearching,
        onSortSelected: _updateSortType,
        onMorePressed: _handleMorePressed,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final visibleVideos = _visibleVideos;
    if (visibleVideos.isEmpty) {
      return _buildEmptyBody();
    }
    return _buildVideoList(visibleVideos);
  }

  List<FavoriteVideoEntry> get _visibleVideos {
    return buildVisibleFavoriteFolderVideos(
      folder: _folder,
      sortType: _sortType,
      searchQuery: _searchQuery,
    );
  }

  Widget _buildEmptyBody() {
    return ListView(
      key: PageStorageKey<String>('favorite_folder_detail_${_folder.id}'),
      padding: _kFavoriteFolderDetailPadding,
      children: <Widget>[
        FavoriteFolderDetailHeader(folder: _folder),
        const SizedBox(height: _kFavoriteFolderDetailHeaderBottom),
        FavoriteFolderDetailEmptyView(searchQuery: _resolveEmptySearchQuery()),
      ],
    );
  }

  Widget _buildVideoList(List<FavoriteVideoEntry> visibleVideos) {
    return ListView.separated(
      key: PageStorageKey<String>('favorite_folder_detail_${_folder.id}'),
      padding: _kFavoriteFolderDetailPadding,
      itemCount: visibleVideos.length + 1,
      separatorBuilder: (_, int index) {
        if (index == 0) {
          return const SizedBox(height: _kFavoriteFolderDetailHeaderBottom);
        }
        return const SizedBox(height: _kFavoriteFolderDetailVideoSpacing);
      },
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return FavoriteFolderDetailHeader(folder: _folder);
        }
        final video = visibleVideos[index - 1];
        return FavoriteFolderVideoTile(
          key: ValueKey<String>('favorite_folder_video_${video.id}'),
          video: video,
          selected: _selectedVideoIds.contains(video.id),
          onTap: () => unawaited(_handleVideoTap(video)),
          onLongPress: () => _toggleSelection(video.id),
        );
      },
    );
  }

  String? _resolveEmptySearchQuery() {
    if (_folder.videos.isEmpty) {
      return null;
    }
    final query = _searchQuery.trim();
    if (query.isEmpty) {
      return null;
    }
    return query;
  }

  void _handleLeadingPressed() {
    if (_isSelectionMode) {
      setState(() {
        _selectedVideoIds = <String>{};
      });
      return;
    }
    Navigator.of(context).maybePop();
  }

  Future<void> _handleVideoTap(FavoriteVideoEntry video) async {
    if (_isSelectionMode) {
      _toggleSelection(video.id);
      return;
    }
    await openFavoriteFolderVideo(
      context: context,
      folder: buildFavoriteFolderPlaybackEntry(
        folder: _folder,
        sortType: _sortType,
      ),
      video: video,
      webDavAccountRepository:
          widget.webDavAccountRepository ?? Get.find<WebDavAccountRepository>(),
    );
  }

  bool _canSelectAllVisibleVideos() {
    final visibleVideoIds = _visibleVideos
        .map((FavoriteVideoEntry video) => video.id)
        .toSet();
    return visibleVideoIds.isNotEmpty &&
        !_selectedVideoIds.containsAll(visibleVideoIds);
  }

  void _selectAllVisibleVideos() {
    final visibleVideoIds = _visibleVideos
        .map((FavoriteVideoEntry video) => video.id)
        .toSet();
    if (visibleVideoIds.isEmpty) {
      return;
    }
    setState(() {
      _selectedVideoIds = visibleVideoIds;
    });
  }

  Future<void> _deleteSelectedVideos() async {
    if (_selectedVideoIds.isEmpty) {
      return;
    }
    final selectedIds = Set<String>.of(_selectedVideoIds);
    final selectedVideos = _folder.videos
        .where((FavoriteVideoEntry video) => selectedIds.contains(video.id))
        .toList(growable: false);
    final confirmed = await showFavoritesConfirmationDialog(
      context,
      title: '\u5220\u9664\u89c6\u9891',
      content:
          '\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684 ${selectedVideos.length} \u4e2a\u89c6\u9891\u5417\uff1f',
      confirmLabel: '\u5220\u9664',
    );
    if (!mounted || !confirmed) {
      return;
    }

    final controller = _favoritesController;
    if (controller != null) {
      controller.removeVideosFromFolder(
        folderId: _folder.id,
        videos: selectedVideos,
      );
      final nextFolder = controller.folderById(_folder.id);
      setState(() {
        _folder =
            nextFolder ??
            buildFavoriteFolderWithoutVideoIds(
              folder: _folder,
              removedIds: selectedIds,
            );
        _selectedVideoIds = <String>{};
      });
      return;
    }

    setState(() {
      _folder = buildFavoriteFolderWithoutVideoIds(
        folder: _folder,
        removedIds: selectedIds,
      );
      _selectedVideoIds = <String>{};
    });
  }

  void _toggleSelection(String videoId) {
    final nextSelectedVideoIds = Set<String>.of(_selectedVideoIds);
    final isAdded = nextSelectedVideoIds.add(videoId);
    if (!isAdded) {
      nextSelectedVideoIds.remove(videoId);
    }
    setState(() {
      _selectedVideoIds = nextSelectedVideoIds;
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

  void _updateSearchQuery(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _updateSortType(FavoriteFolderVideoSortType value) {
    setState(() {
      _sortType = value;
    });
  }

  void _handleMorePressed() {}
}
