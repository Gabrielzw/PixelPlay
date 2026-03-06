import 'package:flutter/material.dart';

import '../../../shared/utils/media_formatters.dart';
import '../../../shared/utils/not_implemented.dart';
import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import '../domain/entities/local_video.dart';
import 'widgets/album_video_tile.dart';

const EdgeInsets kAlbumPagePadding = EdgeInsets.fromLTRB(16, 12, 16, 20);
const double kAlbumPageSectionSpacing = 16;
const double kAlbumVideoSpacing = 12;
const String kAlbumFallbackTitle = '未命名相册';
const String kUnknownAddedTimeLabel = '添加时间未知';
const String kUnknownVideoTitle = '未命名视频';

class AlbumPage extends StatefulWidget {
  final LocalAlbum album;
  final MediaLibraryRepository repository;

  const AlbumPage({super.key, required this.album, required this.repository});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late Future<List<AlbumVideoTileData>> _videosFuture;

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
      body: FutureBuilder<List<AlbumVideoTileData>>(
        future: _videosFuture,
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<AlbumVideoTileData>> snapshot,
            ) {
              if (snapshot.hasError) {
                return _AlbumErrorView(
                  album: widget.album,
                  title: title,
                  message: snapshot.error.toString(),
                  onRetry: _reloadVideos,
                );
              }
              if (!snapshot.hasData) {
                return _AlbumLoadingView(album: widget.album, title: title);
              }

              return _AlbumVideoListView(
                album: widget.album,
                title: title,
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

  Future<List<AlbumVideoTileData>> _loadVideos() async {
    final videos = await widget.repository.loadAlbumVideos(
      widget.album.bucketId,
    );
    return List<AlbumVideoTileData>.unmodifiable(videos.map(_mapVideoTileData));
  }

  AlbumVideoTileData _mapVideoTileData(LocalVideo video) {
    final title = video.title.trim().isEmpty ? kUnknownVideoTitle : video.title;
    final duration = formatVideoDuration(
      Duration(milliseconds: video.durationMs),
    );
    final size = formatFileSize(video.size);

    return AlbumVideoTileData(
      id: video.id.toString(),
      title: title,
      metaText: '$duration · $size',
      addedTimeText: _formatAddedTime(video.dateAdded),
    );
  }
}

class _AlbumVideoListView extends StatelessWidget {
  final LocalAlbum album;
  final String title;
  final List<AlbumVideoTileData> videos;

  const _AlbumVideoListView({
    required this.album,
    required this.title,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<String>('album_video_list_${album.bucketId}'),
      slivers: <Widget>[
        SliverPadding(
          padding: kAlbumPagePadding,
          sliver: SliverToBoxAdapter(
            child: _AlbumSummaryCard(
              title: title,
              videoCount: videos.length,
              latestAddedTimeText: _formatAlbumLatestAddedTime(album),
            ),
          ),
        ),
        if (videos.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _AlbumEmptyView(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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
                    key: ValueKey<String>(video.id),
                    data: video,
                    onTap: () =>
                        showNotImplementedSnackBar(context, '播放器入口尚未接入'),
                  ),
                );
              }, childCount: videos.length),
            ),
          ),
      ],
    );
  }
}

class _AlbumSummaryCard extends StatelessWidget {
  final String title;
  final int videoCount;
  final String latestAddedTimeText;

  const _AlbumSummaryCard({
    required this.title,
    required this.videoCount,
    required this.latestAddedTimeText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: kAlbumPageSectionSpacing),
            _AlbumInfoRow(label: '视频数量', value: '$videoCount 个'),
            _AlbumInfoRow(label: '最近添加', value: latestAddedTimeText),
          ],
        ),
      ),
    );
  }
}

class _AlbumInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _AlbumInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          SizedBox(width: 72, child: Text(label, style: labelStyle)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _AlbumLoadingView extends StatelessWidget {
  final LocalAlbum album;
  final String title;

  const _AlbumLoadingView({required this.album, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: kAlbumPagePadding,
          sliver: SliverToBoxAdapter(
            child: _AlbumSummaryCard(
              title: title,
              videoCount: album.videoCount,
              latestAddedTimeText: _formatAlbumLatestAddedTime(album),
            ),
          ),
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class _AlbumErrorView extends StatelessWidget {
  final LocalAlbum album;
  final String title;
  final String message;
  final Future<void> Function() onRetry;

  const _AlbumErrorView({
    required this.album,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: kAlbumPagePadding,
          sliver: SliverToBoxAdapter(
            child: _AlbumSummaryCard(
              title: title,
              videoCount: album.videoCount,
              latestAddedTimeText: _formatAlbumLatestAddedTime(album),
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
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
                  FilledButton(
                    onPressed: () => onRetry(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

String _resolveAlbumTitle(String bucketName) {
  if (bucketName.trim().isEmpty) {
    return kAlbumFallbackTitle;
  }
  return bucketName;
}

String _formatAlbumLatestAddedTime(LocalAlbum album) {
  return _formatAddedTime(album.latestDateAddedSeconds);
}

String _formatAddedTime(int addedSeconds) {
  if (addedSeconds <= 0) {
    return kUnknownAddedTimeLabel;
  }

  final addedTime = DateTime.fromMillisecondsSinceEpoch(
    addedSeconds * Duration.millisecondsPerSecond,
  );
  return formatChineseDateTime(addedTime);
}
