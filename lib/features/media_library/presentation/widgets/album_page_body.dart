import 'package:flutter/material.dart';

import '../../domain/entities/local_album.dart';
import 'album_video_tile.dart';

const EdgeInsets kAlbumPagePadding = EdgeInsets.fromLTRB(16, 12, 16, 20);
const double kAlbumVideoSpacing = 12;

class AlbumVideoListView extends StatelessWidget {
  final LocalAlbum album;
  final List<AlbumVideoTileData> videos;
  final ValueChanged<int> onVideoTap;

  const AlbumVideoListView({
    super.key,
    required this.album,
    required this.videos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<String>('album_video_list_${album.bucketId}'),
      slivers: <Widget>[
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
                  key: ValueKey<String>(video.id),
                  data: video,
                  onTap: () => onVideoTap(index),
                ),
              );
            }, childCount: videos.length),
          ),
        ),
      ],
    );
  }
}

class AlbumPageLoadingView extends StatelessWidget {
  const AlbumPageLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class AlbumPageErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const AlbumPageErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

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
            FilledButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

class AlbumPageEmptyView extends StatelessWidget {
  final String? query;

  const AlbumPageEmptyView({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    final message = query == null || query!.trim().isEmpty
        ? '当前相册没有可显示的视频信息。'
        : '没有找到与“${query!.trim()}”相关的视频。';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
