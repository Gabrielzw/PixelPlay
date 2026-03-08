import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/utils/media_formatters.dart';
import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';
import '../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import '../domain/entities/local_video.dart';
import 'album_video_sort_type.dart';
import 'widgets/album_page_app_bar.dart';
import 'widgets/album_page_body.dart';
import 'widgets/album_video_tile.dart';

typedef AlbumPlayerRouteBuilder =
    Route<void> Function(List<PlayerQueueItem> playlist, int initialIndex);

const String kAlbumFallbackTitle = '未命名相册';
const String kUnknownVideoTitle = '未命名视频';
const String kUnknownResolutionLabel = '分辨率未知';
const String kUnknownModifiedTimeLabel = '修改时间未知';

class AlbumPage extends StatefulWidget {
  final LocalAlbum album;
  final MediaLibraryRepository repository;
  final AlbumPlayerRouteBuilder? playerRouteBuilder;

  const AlbumPage({
    super.key,
    required this.album,
    required this.repository,
    this.playerRouteBuilder,
  });

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<LocalVideo>> _videosFuture;
  var _isSearching = false;
  var _searchQuery = '';
  var _sortType = AlbumVideoSortType.latest;

  @override
  void initState() {
    super.initState();
    _videosFuture = _loadVideos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _resolveAlbumTitle(widget.album.bucketName);

    return Scaffold(
      appBar: AlbumPageAppBar(
        title: title,
        isSearching: _isSearching,
        searchController: _searchController,
        currentSort: _sortType,
        onSearchChanged: _updateSearchQuery,
        onStartSearching: _startSearching,
        onStopSearching: _stopSearching,
        onSortSelected: _updateSortType,
      ),
      body: FutureBuilder<List<LocalVideo>>(
        future: _videosFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<LocalVideo>> snapshot) {
              if (snapshot.hasError) {
                return AlbumPageErrorView(
                  message: snapshot.error.toString(),
                  onRetry: _reloadVideos,
                );
              }
              if (!snapshot.hasData) {
                return const AlbumPageLoadingView();
              }
              return _buildReadyBody(snapshot.requireData);
            },
      ),
    );
  }

  Widget _buildReadyBody(List<LocalVideo> videos) {
    final visibleVideos = _buildVisibleVideos(videos);
    final query = _searchQuery.trim();
    if (visibleVideos.isEmpty) {
      return AlbumPageEmptyView(query: query.isEmpty ? null : query);
    }

    final visibleEntries = List<_AlbumVideoEntry>.unmodifiable(
      visibleVideos.map(_mapVideoEntry),
    );
    final tiles = List<AlbumVideoTileData>.unmodifiable(
      visibleEntries.map((_AlbumVideoEntry entry) => entry.tileData),
    );

    return AlbumVideoListView(
      album: widget.album,
      videos: tiles,
      onVideoTap: (int index) {
        _openPlayer(context, visibleEntries, index);
      },
    );
  }

  List<LocalVideo> _buildVisibleVideos(List<LocalVideo> videos) {
    final sortedVideos = sortAlbumVideos(videos, _sortType);
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return sortedVideos;
    }

    return List<LocalVideo>.unmodifiable(
      sortedVideos.where(
        (LocalVideo video) => _matchesAlbumVideoQuery(video, normalizedQuery),
      ),
    );
  }

  Future<void> _reloadVideos() async {
    setState(() {
      _videosFuture = _loadVideos();
    });
  }

  Future<List<LocalVideo>> _loadVideos() {
    return widget.repository.loadAlbumVideos(widget.album.bucketId);
  }

  _AlbumVideoEntry _mapVideoEntry(LocalVideo video) {
    final title = video.title.trim().isEmpty ? kUnknownVideoTitle : video.title;
    final totalDurationMs = math.max(video.durationMs, 0);
    final duration = Duration(milliseconds: totalDurationMs);
    final totalDurationText = formatVideoDuration(duration);
    final resolutionText = _formatVideoResolution(video);
    final storedPositionMs = video.lastPlayPositionMs;
    final playbackPositionMs = storedPositionMs == null
        ? null
        : math.max(0, math.min(storedPositionMs, totalDurationMs));
    final progressRatio = playbackPositionMs == null || totalDurationMs == 0
        ? null
        : playbackPositionMs / totalDurationMs;
    final durationText = playbackPositionMs == null
        ? totalDurationText
        : '${formatVideoDuration(Duration(milliseconds: playbackPositionMs))}/$totalDurationText';

    return _AlbumVideoEntry(
      tileData: AlbumVideoTileData(
        id: video.id.toString(),
        title: title,
        durationText: durationText,
        resolutionText: resolutionText,
        sizeText: formatFileSize(video.size),
        modifiedTimeText: _formatModifiedTime(video.dateModified),
        progressRatio: progressRatio,
        previewSeed: video.id,
        thumbnailRequest: VideoThumbnailRequest.tile(
          videoId: video.id,
          videoPath: video.path,
          dateModified: video.dateModified,
        ),
      ),
      playerItem: PlayerQueueItem(
        id: video.id.toString(),
        title: title,
        sourceLabel: _resolveAlbumTitle(video.bucketName),
        path: video.path,
        duration: duration,
        resolutionText: resolutionText == kUnknownResolutionLabel
            ? null
            : resolutionText,
        previewAspectRatio: _resolvePreviewAspectRatio(video),
        lastKnownPositionMs: playbackPositionMs,
      ),
    );
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

  void _updateSortType(AlbumVideoSortType value) {
    setState(() {
      _sortType = value;
    });
  }

  Future<void> _openPlayer(
    BuildContext context,
    List<_AlbumVideoEntry> videos,
    int initialIndex,
  ) async {
    final playlist = videos
        .map((_AlbumVideoEntry entry) => entry.playerItem)
        .toList(growable: false);

    await Navigator.of(
      context,
      rootNavigator: true,
    ).push(_buildPlayerRoute(playlist, initialIndex));
    if (!mounted) {
      return;
    }
    await _reloadVideos();
  }

  Route<void> _buildPlayerRoute(
    List<PlayerQueueItem> playlist,
    int initialIndex,
  ) {
    final builder = widget.playerRouteBuilder;
    if (builder != null) {
      return builder(playlist, initialIndex);
    }

    return buildPlayerPageRoute(
      child: PlayerPage(playlist: playlist, initialIndex: initialIndex),
    );
  }
}

@immutable
class _AlbumVideoEntry {
  final AlbumVideoTileData tileData;
  final PlayerQueueItem playerItem;

  const _AlbumVideoEntry({required this.tileData, required this.playerItem});
}

bool _matchesAlbumVideoQuery(LocalVideo video, String normalizedQuery) {
  if (normalizedQuery.isEmpty) {
    return true;
  }

  final title = video.title.toLowerCase();
  final path = video.path.toLowerCase();
  return title.contains(normalizedQuery) || path.contains(normalizedQuery);
}

String _resolveAlbumTitle(String bucketName) {
  if (bucketName.trim().isEmpty) {
    return kAlbumFallbackTitle;
  }
  return bucketName;
}

String _formatVideoResolution(LocalVideo video) {
  if (video.width <= 0 || video.height <= 0) {
    return kUnknownResolutionLabel;
  }

  return formatResolution(width: video.width, height: video.height);
}

String _formatModifiedTime(int modifiedSeconds) {
  if (modifiedSeconds <= 0) {
    return kUnknownModifiedTimeLabel;
  }

  final modifiedTime = DateTime.fromMillisecondsSinceEpoch(
    modifiedSeconds * Duration.millisecondsPerSecond,
  );
  return formatChineseDateTime(modifiedTime);
}

double _resolvePreviewAspectRatio(LocalVideo video) {
  if (video.width <= 0 || video.height <= 0) {
    return kDefaultPreviewAspectRatio;
  }
  return video.width / video.height;
}
