import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import 'favorite_folder_player_launcher.dart';
import 'favorite_folder_video_sort_type.dart';
import 'favorite_models.dart';
import 'widgets/favorite_folder_detail_app_bar.dart';
import 'widgets/favorite_folder_detail_empty_view.dart';
import 'widgets/favorite_folder_detail_header.dart';
import 'widgets/favorite_folder_video_tile.dart';

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
  final WebDavAccountRepository? webDavAccountRepository;

  const FavoriteFolderDetailPage({
    super.key,
    required this.folder,
    this.webDavAccountRepository,
  });

  @override
  State<FavoriteFolderDetailPage> createState() =>
      _FavoriteFolderDetailPageState();
}

class _FavoriteFolderDetailPageState extends State<FavoriteFolderDetailPage> {
  late final TextEditingController _searchController;
  Set<String> _selectedVideoIds = <String>{};
  String _searchQuery = '';
  bool _isSearching = false;
  FavoriteFolderVideoSortType _sortType = FavoriteFolderVideoSortType.latest;

  bool get _isSelectionMode => _selectedVideoIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
        selectedCount: _selectedVideoIds.length,
        searchController: _searchController,
        currentSort: _sortType,
        onLeadingPressed: _handleLeadingPressed,
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
    final visibleVideos = _buildVisibleVideos();
    if (visibleVideos.isEmpty) {
      return _buildEmptyBody();
    }
    return _buildVideoList(visibleVideos);
  }

  Widget _buildEmptyBody() {
    return ListView(
      key: PageStorageKey<String>('favorite_folder_detail_${widget.folder.id}'),
      padding: _kFavoriteFolderDetailPadding,
      children: <Widget>[
        FavoriteFolderDetailHeader(folder: widget.folder),
        const SizedBox(height: _kFavoriteFolderDetailHeaderBottom),
        FavoriteFolderDetailEmptyView(searchQuery: _resolveEmptySearchQuery()),
      ],
    );
  }

  Widget _buildVideoList(List<FavoriteVideoEntry> visibleVideos) {
    return ListView.separated(
      key: PageStorageKey<String>('favorite_folder_detail_${widget.folder.id}'),
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
          return FavoriteFolderDetailHeader(folder: widget.folder);
        }

        final video = visibleVideos[index - 1];
        return FavoriteFolderVideoTile(
          key: ValueKey<String>('favorite_folder_video_${video.id}'),
          video: video,
          selected: _selectedVideoIds.contains(video.id),
          onTap: () => unawaited(_handleVideoTap(video)),
          onLongPress: () => _handleVideoLongPress(video.id),
        );
      },
    );
  }

  List<FavoriteVideoEntry> _buildVisibleVideos() {
    final sortedVideos = sortFavoriteFolderVideos(
      widget.folder.videos,
      _sortType,
    );
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return sortedVideos;
    }

    return List<FavoriteVideoEntry>.unmodifiable(
      sortedVideos.where(
        (FavoriteVideoEntry video) => _matchesFavoriteVideoQuery(
          video: video,
          normalizedQuery: normalizedQuery,
        ),
      ),
    );
  }

  String? _resolveEmptySearchQuery() {
    if (widget.folder.videos.isEmpty) {
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
      folder: _buildPlaybackFolder(),
      video: video,
      webDavAccountRepository:
          widget.webDavAccountRepository ?? Get.find<WebDavAccountRepository>(),
    );
  }

  FavoriteFolderEntry _buildPlaybackFolder() {
    return FavoriteFolderEntry(
      id: widget.folder.id,
      title: widget.folder.title,
      createdAt: widget.folder.createdAt,
      videos: sortFavoriteFolderVideos(widget.folder.videos, _sortType),
    );
  }

  void _handleVideoLongPress(String videoId) {
    _toggleSelection(videoId);
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

bool _matchesFavoriteVideoQuery({
  required FavoriteVideoEntry video,
  required String normalizedQuery,
}) {
  final searchTargets = <String>[
    video.title,
    video.sourceLabel ?? '',
    video.playbackPath ?? '',
    video.sourceUri ?? '',
  ];
  return searchTargets.any(
    (String value) => value.trim().toLowerCase().contains(normalizedQuery),
  );
}
