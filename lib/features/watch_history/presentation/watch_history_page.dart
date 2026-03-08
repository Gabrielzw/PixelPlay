import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/utils/media_formatters.dart';
import '../../../shared/utils/not_implemented.dart';
import '../../media_library/presentation/widgets/album_page_body.dart';
import '../../media_library/presentation/widgets/album_video_tile.dart';
import '../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import '../domain/watch_history_repository.dart';
import 'watch_history_player_launcher.dart';
import 'widgets/watch_history_video_tile.dart';

enum _WatchHistoryAction { clear }

class WatchHistoryPage extends StatefulWidget {
  const WatchHistoryPage({super.key});

  @override
  State<WatchHistoryPage> createState() => _WatchHistoryPageState();
}

class _WatchHistoryPageState extends State<WatchHistoryPage> {
  late Future<List<WatchHistoryRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('观看记录'),
        actions: <Widget>[
          IconButton(
            tooltip: '搜索',
            onPressed: () => showNotImplementedSnackBar(context, '搜索功能尚未接入'),
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<_WatchHistoryAction>(
            tooltip: '选项',
            icon: const Icon(Icons.more_vert),
            onSelected: (_WatchHistoryAction action) {
              switch (action) {
                case _WatchHistoryAction.clear:
                  showNotImplementedSnackBar(context, '清空观看记录功能尚未接入');
              }
            },
            itemBuilder: (BuildContext context) {
              return const <PopupMenuEntry<_WatchHistoryAction>>[
                PopupMenuItem<_WatchHistoryAction>(
                  value: _WatchHistoryAction.clear,
                  child: Text('清空观看记录'),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<WatchHistoryRecord>>(
        future: _recordsFuture,
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<WatchHistoryRecord>> snapshot,
            ) {
              if (snapshot.hasError) {
                return AlbumPageErrorView(
                  message: snapshot.error.toString(),
                  onRetry: _reloadRecords,
                );
              }
              if (!snapshot.hasData) {
                return const AlbumPageLoadingView();
              }

              final records = snapshot.requireData;
              if (records.isEmpty) {
                return const _WatchHistoryEmptyView();
              }
              return _WatchHistoryListView(
                records: records,
                onTapRecord: _handleRecordTap,
              );
            },
      ),
    );
  }

  Future<void> _handleRecordTap(WatchHistoryRecord record) async {
    await openWatchHistoryRecord(
      context: context,
      record: record,
      webDavAccountRepository: Get.find<WebDavAccountRepository>(),
    );
    if (!mounted) {
      return;
    }
    await _reloadRecords();
  }

  Future<List<WatchHistoryRecord>> _loadRecords() {
    return Get.find<WatchHistoryRepository>().loadAll();
  }

  Future<void> _reloadRecords() async {
    setState(() {
      _recordsFuture = _loadRecords();
    });
  }
}

class _WatchHistoryListView extends StatelessWidget {
  final List<WatchHistoryRecord> records;
  final ValueChanged<WatchHistoryRecord> onTapRecord;

  const _WatchHistoryListView({
    required this.records,
    required this.onTapRecord,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = List<WatchHistoryVideoTileData>.unmodifiable(
      records.map(_buildTileData),
    );

    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: kAlbumPagePadding,
          sliver: SliverFixedExtentList(
            itemExtent: kAlbumVideoTileHeight + kAlbumVideoSpacing,
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return Padding(
                padding: const EdgeInsets.only(bottom: kAlbumVideoSpacing),
                child: WatchHistoryVideoTile(
                  key: ValueKey<String>(tiles[index].id),
                  data: tiles[index],
                  onTap: () => onTapRecord(records[index]),
                ),
              );
            }, childCount: records.length),
          ),
        ),
      ],
    );
  }

  WatchHistoryVideoTileData _buildTileData(WatchHistoryRecord record) {
    return WatchHistoryVideoTileData(
      id: record.mediaId,
      title: record.title,
      sourceText: record.sourceLabel,
      watchedTimeText: _formatWatchedTime(record.watchedAtMs),
      durationText: _formatDurationText(record),
      progressRatio: record.progressRatio,
      previewSeed: record.mediaId.hashCode.abs(),
      thumbnailRequest: _buildThumbnailRequest(record),
    );
  }
}

VideoThumbnailRequest? _buildThumbnailRequest(WatchHistoryRecord record) {
  final videoId = record.localVideoId;
  final videoPath = record.mediaPath;
  final dateModified = record.localVideoDateModified;
  if (videoId == null ||
      videoPath == null ||
      dateModified == null ||
      record.isRemote) {
    return null;
  }

  return VideoThumbnailRequest.tile(
    videoId: videoId,
    videoPath: videoPath,
    dateModified: dateModified,
  );
}

String _formatDurationText(WatchHistoryRecord record) {
  final safeDurationMs = record.durationMs < 0 ? 0 : record.durationMs;
  final duration = Duration(milliseconds: safeDurationMs);
  final maxPositionMs = safeDurationMs > 0 ? safeDurationMs : record.positionMs;
  final safePositionMs = record.positionMs.clamp(0, maxPositionMs).toInt();
  final position = Duration(milliseconds: safePositionMs);
  if (safeDurationMs <= 0) {
    return formatVideoDuration(position);
  }

  return '${formatVideoDuration(position)}/${formatVideoDuration(duration)}';
}

String _formatWatchedTime(int watchedAtMs) {
  final watchedAt = DateTime.fromMillisecondsSinceEpoch(watchedAtMs);
  return formatChineseDateTime(watchedAt);
}

class _WatchHistoryEmptyView extends StatelessWidget {
  const _WatchHistoryEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '当前还没有观看记录。',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
