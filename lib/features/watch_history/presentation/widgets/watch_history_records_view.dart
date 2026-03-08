import 'package:flutter/material.dart';

import '../../../../shared/domain/media_source_kind.dart';
import '../../../../shared/utils/media_formatters.dart';
import '../../../media_library/presentation/widgets/album_page_body.dart';
import '../../../media_library/presentation/widgets/album_video_tile.dart';
import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../domain/watch_history_repository.dart';
import 'watch_history_video_tile.dart';

enum WatchHistoryFilter { all, local, webDav, other }

extension WatchHistoryFilterPresentation on WatchHistoryFilter {
  String get label => switch (this) {
    WatchHistoryFilter.all => '全部',
    WatchHistoryFilter.local => '本地',
    WatchHistoryFilter.webDav => 'WebDAV',
    WatchHistoryFilter.other => '其他',
  };
}

List<WatchHistoryRecord> filterWatchHistoryRecords(
  List<WatchHistoryRecord> records,
  WatchHistoryFilter filter,
) {
  if (filter == WatchHistoryFilter.all) {
    return records;
  }

  return records
      .where((WatchHistoryRecord record) {
        return switch (filter) {
          WatchHistoryFilter.all => true,
          WatchHistoryFilter.local =>
            record.sourceKind == MediaSourceKind.local,
          WatchHistoryFilter.webDav =>
            record.sourceKind == MediaSourceKind.webDav,
          WatchHistoryFilter.other =>
            record.sourceKind == MediaSourceKind.other,
        };
      })
      .toList(growable: false);
}

List<WatchHistoryRecord> buildVisibleWatchHistoryRecords(
  List<WatchHistoryRecord> records,
  WatchHistoryFilter filter,
  String searchQuery,
) {
  final filteredRecords = filterWatchHistoryRecords(records, filter);
  final normalizedQuery = searchQuery.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return filteredRecords;
  }

  return filteredRecords
      .where(
        (WatchHistoryRecord record) =>
            matchesWatchHistoryRecordQuery(record, normalizedQuery),
      )
      .toList(growable: false);
}

bool matchesWatchHistoryRecordQuery(
  WatchHistoryRecord record,
  String normalizedQuery,
) {
  if (normalizedQuery.isEmpty) {
    return true;
  }

  final searchTargets = <String>[
    record.title,
    record.sourceLabel,
    record.mediaId,
    record.mediaPath ?? '',
    record.sourceUri ?? '',
  ];
  return searchTargets.any(
    (String value) => value.toLowerCase().contains(normalizedQuery),
  );
}

class WatchHistoryRecordsView extends StatelessWidget {
  final List<WatchHistoryRecord> records;
  final WatchHistoryFilter filter;
  final String searchQuery;
  final Set<String> selectedRecordIds;
  final ValueChanged<WatchHistoryRecord> onTapRecord;
  final ValueChanged<WatchHistoryRecord> onLongPressRecord;
  final ValueChanged<WatchHistoryRecord> onToggleSelection;

  const WatchHistoryRecordsView({
    super.key,
    required this.records,
    required this.filter,
    required this.searchQuery,
    required this.selectedRecordIds,
    required this.onTapRecord,
    required this.onLongPressRecord,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final visibleRecords = buildVisibleWatchHistoryRecords(
      records,
      filter,
      searchQuery,
    );
    if (visibleRecords.isEmpty) {
      return WatchHistoryEmptyView(filter: filter, searchQuery: searchQuery);
    }

    final isSelectionMode = selectedRecordIds.isNotEmpty;
    final tiles = List<WatchHistoryVideoTileData>.unmodifiable(
      visibleRecords.map(_buildTileData),
    );

    return CustomScrollView(
      key: PageStorageKey<String>('watch_history_${filter.name}'),
      slivers: <Widget>[
        SliverPadding(
          padding: kAlbumPagePadding,
          sliver: SliverFixedExtentList(
            itemExtent: kAlbumVideoTileHeight + kAlbumVideoSpacing,
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final record = visibleRecords[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: kAlbumVideoSpacing),
                child: WatchHistoryVideoTile(
                  key: ValueKey<String>('watch_history_tile_${record.mediaId}'),
                  data: tiles[index],
                  selected: selectedRecordIds.contains(record.mediaId),
                  onTap: () => _handleTileTap(record, isSelectionMode),
                  onLongPress: () => onLongPressRecord(record),
                ),
              );
            }, childCount: visibleRecords.length),
          ),
        ),
      ],
    );
  }

  void _handleTileTap(WatchHistoryRecord record, bool isSelectionMode) {
    if (isSelectionMode) {
      onToggleSelection(record);
      return;
    }
    onTapRecord(record);
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

class WatchHistoryEmptyView extends StatelessWidget {
  final WatchHistoryFilter filter;
  final String searchQuery;

  const WatchHistoryEmptyView({
    super.key,
    required this.filter,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          _resolveEmptyMessage(filter, searchQuery),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
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

String _resolveEmptyMessage(WatchHistoryFilter filter, String searchQuery) {
  final normalizedQuery = searchQuery.trim();
  if (normalizedQuery.isNotEmpty) {
    return '没有找到匹配“$normalizedQuery”的观看记录。';
  }
  if (filter == WatchHistoryFilter.all) {
    return '当前还没有观看记录。';
  }
  return '当前分类还没有观看记录。';
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
