import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/features/thumbnail_engine/data/in_memory_thumbnail_queue.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/thumbnail_queue.dart';
import 'package:pixelplay/features/watch_history/data/in_memory_watch_history_repository.dart';
import 'package:pixelplay/features/watch_history/domain/watch_history_repository.dart';
import 'package:pixelplay/features/watch_history/presentation/watch_history_page.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_account_repository.dart';
import 'package:pixelplay/features/webdav_client/domain/contracts/webdav_account_repository.dart';
import 'package:pixelplay/shared/domain/media_source_kind.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('watch history page shows source tabs and filters records', (
    WidgetTester tester,
  ) async {
    await _pumpHistoryPage(tester, repository: _buildHistoryRepository());

    expect(find.text('观看记录'), findsOneWidget);
    expect(find.text('全部'), findsOneWidget);
    expect(find.text('本地'), findsOneWidget);
    expect(find.text('WebDAV'), findsOneWidget);
    expect(find.text('其他'), findsOneWidget);
    expect(find.byTooltip('搜索'), findsOneWidget);
    expect(find.byTooltip('选项'), findsOneWidget);

    expect(find.text('Trailer.mp4'), findsOneWidget);
    expect(find.text('Beach Walk.mp4'), findsOneWidget);
    expect(find.text('demo.m3u8'), findsOneWidget);
    expect(find.text('01:20/03:35'), findsOneWidget);
    expect(find.text('00:45/02:00'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);

    await tester.tap(find.text('本地'));
    await tester.pumpAndSettle();
    expect(find.text('Beach Walk.mp4'), findsOneWidget);
    expect(find.text('Trailer.mp4'), findsNothing);
    expect(find.text('demo.m3u8'), findsNothing);

    await tester.tap(find.text('WebDAV'));
    await tester.pumpAndSettle();
    expect(find.text('Trailer.mp4'), findsOneWidget);
    expect(find.text('Beach Walk.mp4'), findsNothing);
    expect(find.text('demo.m3u8'), findsNothing);

    await tester.tap(find.text('其他'));
    await tester.pumpAndSettle();
    expect(find.text('demo.m3u8'), findsOneWidget);
    expect(find.text('Trailer.mp4'), findsNothing);
    expect(find.text('Beach Walk.mp4'), findsNothing);

    await tester.tap(find.byTooltip('选项'));
    await tester.pumpAndSettle();
    expect(find.text('清空观看记录'), findsOneWidget);
  });

  testWidgets('watch history page shows filtered empty state', (
    WidgetTester tester,
  ) async {
    final repository = InMemoryWatchHistoryRepository(
      initialRecords: <String, WatchHistoryRecord>{
        '1': _buildLocalRecord(
          mediaId: '1',
          title: 'Beach Walk.mp4',
          watchedAtMs: 1700000000000,
          positionMs: 80000,
          durationMs: 215000,
          localVideoId: 1,
        ),
      },
    );
    await _pumpHistoryPage(tester, repository: repository);

    await tester.tap(find.text('WebDAV'));
    await tester.pumpAndSettle();

    expect(find.text('当前分类还没有观看记录。'), findsOneWidget);
  });

  testWidgets('watch history page supports searching records', (
    WidgetTester tester,
  ) async {
    await _pumpHistoryPage(
      tester,
      repository: _buildHistoryRepository(includeSecondLocal: true),
    );

    await tester.tap(find.byTooltip('搜索'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'trail');
    await tester.pumpAndSettle();

    expect(find.text('Trailer.mp4'), findsOneWidget);
    expect(find.text('Beach Walk.mp4'), findsNothing);
    expect(find.text('Sunset.mp4'), findsNothing);
    expect(find.text('demo.m3u8'), findsNothing);

    await tester.tap(find.byTooltip('关闭搜索'));
    await tester.pumpAndSettle();

    expect(find.text('Trailer.mp4'), findsOneWidget);
    expect(find.text('Beach Walk.mp4'), findsOneWidget);
    expect(find.text('Sunset.mp4'), findsOneWidget);
    expect(find.text('demo.m3u8'), findsOneWidget);
  });

  testWidgets('watch history page clears all records', (
    WidgetTester tester,
  ) async {
    final repository = _buildHistoryRepository(includeSecondLocal: true);
    await _pumpHistoryPage(tester, repository: repository);

    await tester.tap(find.byTooltip('选项'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('清空观看记录'));
    await tester.pumpAndSettle();

    expect(find.text('清空全部观看记录？'), findsOneWidget);

    await tester.tap(find.text('清空'));
    await tester.pumpAndSettle();

    expect(find.text('当前还没有观看记录。'), findsOneWidget);
    expect(await repository.loadAll(), isEmpty);
  });

  testWidgets('watch history page supports selection mode per tab', (
    WidgetTester tester,
  ) async {
    await _pumpHistoryPage(
      tester,
      repository: _buildHistoryRepository(includeSecondLocal: true),
    );

    await tester.tap(find.text('本地'));
    await tester.pumpAndSettle();

    await tester.longPress(
      find.byKey(const ValueKey<String>('watch_history_tile_1')),
    );
    await tester.pumpAndSettle();

    expect(find.text('已选择 1 项'), findsOneWidget);
    expect(find.byTooltip('全选当前选项卡'), findsOneWidget);
    expect(find.byTooltip('移除所选'), findsOneWidget);

    await tester.tap(find.byTooltip('全选当前选项卡'));
    await tester.pumpAndSettle();

    expect(find.text('已选择 2 项'), findsOneWidget);

    await tester.tap(find.byTooltip('移除所选'));
    await tester.pumpAndSettle();

    expect(find.text('移除所选观看记录？'), findsOneWidget);

    await tester.tap(find.text('移除'));
    await tester.pumpAndSettle();

    expect(find.text('当前分类还没有观看记录。'), findsOneWidget);

    await tester.tap(find.text('全部'));
    await tester.pumpAndSettle();

    expect(find.text('Beach Walk.mp4'), findsNothing);
    expect(find.text('Sunset.mp4'), findsNothing);
    expect(find.text('Trailer.mp4'), findsOneWidget);
    expect(find.text('demo.m3u8'), findsOneWidget);
  });
}

Future<void> _pumpHistoryPage(
  WidgetTester tester, {
  required WatchHistoryRepository repository,
}) async {
  Get.put<ThumbnailQueue>(InMemoryThumbnailQueue());
  Get.put<WatchHistoryRepository>(repository);
  Get.put<WebDavAccountRepository>(InMemoryWebDavAccountRepository());

  await tester.pumpWidget(const GetMaterialApp(home: WatchHistoryPage()));
  await tester.pumpAndSettle();
}

InMemoryWatchHistoryRepository _buildHistoryRepository({
  bool includeSecondLocal = false,
}) {
  final records = <String, WatchHistoryRecord>{
    '1': _buildLocalRecord(
      mediaId: '1',
      title: 'Beach Walk.mp4',
      watchedAtMs: 1700000000000,
      positionMs: 80000,
      durationMs: 215000,
      localVideoId: 1,
    ),
    '/videos/trailer.mp4': const WatchHistoryRecord(
      mediaId: '/videos/trailer.mp4',
      title: 'Trailer.mp4',
      sourceLabel: '家庭云盘 /videos',
      watchedAtMs: 1700001000000,
      positionMs: 0,
      durationMs: 0,
      sourceKind: MediaSourceKind.webDav,
      mediaPath: '/videos/trailer.mp4',
      webDavAccountId: 'webdav_1',
    ),
    'https://example.com/live/demo.m3u8': const WatchHistoryRecord(
      mediaId: 'https://example.com/live/demo.m3u8',
      title: 'demo.m3u8',
      sourceLabel: '其他 / example.com',
      watchedAtMs: 1700002000000,
      positionMs: 45000,
      durationMs: 120000,
      sourceKind: MediaSourceKind.other,
      sourceUri: 'https://example.com/live/demo.m3u8',
    ),
  };
  if (includeSecondLocal) {
    records['2'] = _buildLocalRecord(
      mediaId: '2',
      title: 'Sunset.mp4',
      watchedAtMs: 1700000500000,
      positionMs: 20000,
      durationMs: 100000,
      localVideoId: 2,
    );
  }

  return InMemoryWatchHistoryRepository(initialRecords: records);
}

WatchHistoryRecord _buildLocalRecord({
  required String mediaId,
  required String title,
  required int watchedAtMs,
  required int positionMs,
  required int durationMs,
  required int localVideoId,
}) {
  return WatchHistoryRecord(
    mediaId: mediaId,
    title: title,
    sourceLabel: 'Screenshots',
    watchedAtMs: watchedAtMs,
    positionMs: positionMs,
    durationMs: durationMs,
    sourceKind: MediaSourceKind.local,
    mediaPath: 'content://media/external/video/media/$localVideoId',
    localVideoId: localVideoId,
    localVideoDateModified: 1699999999,
  );
}
