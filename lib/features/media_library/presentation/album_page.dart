import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/utils/media_formatters.dart';
import '../../../shared/utils/not_implemented.dart';
import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';
import '../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import '../domain/entities/local_video.dart';
import 'widgets/album_video_tile.dart';

const EdgeInsets kAlbumPagePadding = EdgeInsets.fromLTRB(16, 12, 16, 20);
const double kAlbumVideoSpacing = 12;
const String kAlbumFallbackTitle = '未命名相册';
const String kUnknownVideoTitle = '未命名视频';
const String kUnknownResolutionLabel = '分辨率未知';
const String kUnknownModifiedTimeLabel = '修改时间未知';

class AlbumPage extends StatefulWidget {
  final LocalAlbum album;
  final MediaLibraryRepository repository;

  const AlbumPage({super.key, required this.album, required this.repository});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late Future<List<_AlbumVideoEntry>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _videosFuture = _loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    final title = _resolveAlbumTitle(widget.album.bucketName);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            tooltip: '搜索',
            onPressed: () => showNotImplementedSnackBar(context, '搜索功能尚未接入'),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: '排序',
            onPressed: () => showNotImplementedSnackBar(context, '排序功能尚未接入'),
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: FutureBuilder<List<_AlbumVideoEntry>>(
        future: _videosFuture,
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<_AlbumVideoEntry>> snapshot,
            ) {
              if (snapshot.hasError) {
                return _AlbumErrorView(
                  message: snapshot.error.toString(),
                  onRetry: _reloadVideos,
                );
              }
              if (!snapshot.hasData) {
                return const _AlbumLoadingView();
              }

              return _AlbumVideoListView(
                album: widget.album,
                videos: snapshot.requireData,
              );
            },
      ),
    );
  }

  Future<void> _reloadVideos() async {
    setState(() {
      _videosFuture = _loadVideos();
    });
  }

  Future<List<_AlbumVideoEntry>> _loadVideos() async {
    final videos = await widget.repository.loadAlbumVideos(
      widget.album.bucketId,
    );
    return List<_AlbumVideoEntry>.unmodifiable(videos.map(_mapVideoEntry));
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
}

class _AlbumVideoListView extends StatelessWidget {
  final LocalAlbum album;
  final List<_AlbumVideoEntry> videos;

  const _AlbumVideoListView({required this.album, required this.videos});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<String>('album_video_list_${album.bucketId}'),
      slivers: <Widget>[
        if (videos.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _AlbumEmptyView(),
          )
        else
          SliverPadding(
            padding: kAlbumPagePadding,
            sliver: SliverFixedExtentList(
              itemExtent: kAlbumVideoTileHeight + kAlbumVideoSpacing,
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                final video = videos[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: kAlbumVideoSpacing),
                  child: AlbumVideoTile(
                    key: ValueKey<String>(video.tileData.id),
                    data: video.tileData,
                    onTap: () => _openPlayer(context, index),
                  ),
                );
              }, childCount: videos.length),
            ),
          ),
      ],
    );
  }

  void _openPlayer(BuildContext context, int initialIndex) {
    final playlist = videos
        .map((_AlbumVideoEntry entry) => entry.playerItem)
        .toList(growable: false);

    Navigator.of(context, rootNavigator: true).push(
      buildPlayerPageRoute(
        child: PlayerPage(playlist: playlist, initialIndex: initialIndex),
      ),
    );
  }
}

class _AlbumLoadingView extends StatelessWidget {
  const _AlbumLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _AlbumErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _AlbumErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              size: 36,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => onRetry(), child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

class _AlbumEmptyView extends StatelessWidget {
  const _AlbumEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '当前相册没有可显示的视频信息。',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

@immutable
class _AlbumVideoEntry {
  final AlbumVideoTileData tileData;
  final PlayerQueueItem playerItem;

  const _AlbumVideoEntry({required this.tileData, required this.playerItem});
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
