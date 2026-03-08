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

  testWidgets('watch history page shows local webdav and other records', (
    WidgetTester tester,
  ) async {
    Get.put<ThumbnailQueue>(InMemoryThumbnailQueue());
    Get.put<WatchHistoryRepository>(
      InMemoryWatchHistoryRepository(
        initialRecords: <String, WatchHistoryRecord>{
          '1': const WatchHistoryRecord(
            mediaId: '1',
            title: 'Beach Walk.mp4',
            sourceLabel: 'Screenshots',
            watchedAtMs: 1700000000000,
            positionMs: 80000,
            durationMs: 215000,
            sourceKind: MediaSourceKind.local,
            mediaPath: 'content://media/external/video/media/1',
            localVideoId: 1,
            localVideoDateModified: 1699999999,
          ),
          '/videos/trailer.mp4': const WatchHistoryRecord(
            mediaId: '/videos/trailer.mp4',
            title: 'Trailer.mp4',
            sourceLabel: '\u5bb6\u5ead\u4e91\u76d8 /videos',
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
            sourceLabel: '\u5176\u4ed6 / example.com',
            watchedAtMs: 1700002000000,
            positionMs: 45000,
            durationMs: 120000,
            sourceKind: MediaSourceKind.other,
            sourceUri: 'https://example.com/live/demo.m3u8',
          ),
        },
      ),
    );
    Get.put<WebDavAccountRepository>(InMemoryWebDavAccountRepository());

    await tester.pumpWidget(const GetMaterialApp(home: WatchHistoryPage()));
    await tester.pumpAndSettle();

    expect(find.text('\u89c2\u770b\u8bb0\u5f55'), findsOneWidget);
    expect(find.byTooltip('\u641c\u7d22'), findsOneWidget);
    expect(find.byTooltip('\u9009\u9879'), findsOneWidget);
    expect(find.text('Trailer.mp4'), findsOneWidget);
    expect(find.text('Beach Walk.mp4'), findsOneWidget);
    expect(find.text('demo.m3u8'), findsOneWidget);
    expect(find.text('\u5bb6\u5ead\u4e91\u76d8 /videos'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('\u5176\u4ed6 / example.com'), findsOneWidget);
    expect(find.text('01:20/03:35'), findsOneWidget);
    expect(find.text('00:45/02:00'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);

    await tester.tap(find.byTooltip('\u9009\u9879'));
    await tester.pumpAndSettle();

    expect(find.text('\u6e05\u7a7a\u89c2\u770b\u8bb0\u5f55'), findsOneWidget);
  });
}
