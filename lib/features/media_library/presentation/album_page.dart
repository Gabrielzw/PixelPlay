import 'package:flutter/material.dart';

import '../../../shared/utils/media_formatters.dart';
import '../../../shared/utils/not_implemented.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import '../domain/entities/local_album.dart';

const double kAlbumPageSpacing = 12;
const EdgeInsets kAlbumPagePadding = EdgeInsets.all(16);
const String kAlbumFallbackTitle = '未命名相册';

class AlbumPage extends StatelessWidget {
  final LocalAlbum album;

  const AlbumPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final title = _resolveAlbumTitle(album.bucketName);

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
      body: ListView(
        padding: kAlbumPagePadding,
        children: <Widget>[
          const UiSkeletonNotice(
            message: '当前阶段仅接入相册聚合信息；缩略图、视频列表、筛选与排序尚未接入。',
          ),
          const SizedBox(height: kAlbumPageSpacing),
          _AlbumInfoCard(album: album, title: title),
        ],
      ),
    );
  }
}

class _AlbumInfoCard extends StatelessWidget {
  final LocalAlbum album;
  final String title;

  const _AlbumInfoCard({required this.album, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: kAlbumPageSpacing),
            _AlbumInfoRow(label: '视频数量', value: '${album.videoCount} 个'),
            _AlbumInfoRow(label: '最近添加', value: _formatLatestAddedTime(album)),
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

String _resolveAlbumTitle(String bucketName) {
  if (bucketName.trim().isEmpty) {
    return kAlbumFallbackTitle;
  }
  return bucketName;
}

String _formatLatestAddedTime(LocalAlbum album) {
  if (album.latestDateAddedSeconds <= 0) {
    return '未知';
  }

  final latestAddedAt = DateTime.fromMillisecondsSinceEpoch(
    album.latestDateAddedSeconds * Duration.millisecondsPerSecond,
  );
  return formatChineseDateTime(latestAddedAt);
}
