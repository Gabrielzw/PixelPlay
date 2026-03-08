import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/features/thumbnail_engine/data/in_memory_thumbnail_queue.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/thumbnail_queue.dart';
import 'package:pixelplay/features/watch_history/data/in_memory_watch_history_repository.dart';
import 'package:pixelplay/features/watch_history/domain/watch_history_repository.dart';
import 'package:pixelplay/features/watch_history/presentation/watch_history_page.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_account_repository.dart';
import 'package:pixelplay/features/webdav_client/domain/contracts/webdav_account_repository.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('watch history page shows local and webdav records', (
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
            isRemote: false,
            mediaPath: 'content://media/external/video/media/1',
            localVideoId: 1,
            localVideoDateModified: 1699999999,
          ),
          '/videos/trailer.mp4': const WatchHistoryRecord(
            mediaId: '/videos/trailer.mp4',
            title: 'Trailer.mp4',
            sourceLabel: '家庭云盘 /videos',
            watchedAtMs: 1700001000000,
            positionMs: 0,
            durationMs: 0,
            isRemote: true,
            mediaPath: '/videos/trailer.mp4',
            webDavAccountId: 'webdav_1',
          ),
        },
      ),
    );
    Get.put<WebDavAccountRepository>(InMemoryWebDavAccountRepository());

    await tester.pumpWidget(const GetMaterialApp(home: WatchHistoryPage()));
    await tester.pumpAndSettle();

    expect(find.text('观看记录'), findsOneWidget);
    expect(find.byTooltip('搜索'), findsOneWidget);
    expect(find.byTooltip('选项'), findsOneWidget);
    expect(find.text('Trailer.mp4'), findsOneWidget);
    expect(find.text('Beach Walk.mp4'), findsOneWidget);
    expect(find.text('家庭云盘 /videos'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('01:20/03:35'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);

    await tester.tap(find.byTooltip('选项'));
    await tester.pumpAndSettle();

    expect(find.text('清空观看记录'), findsOneWidget);
  });
}
