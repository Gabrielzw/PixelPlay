import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pixelplay/features/player_core/domain/playback_position_repository.dart';
import 'package:pixelplay/features/settings/data/app_cache_cleaner.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/settings/domain/cache_settings_controller.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';
import 'package:pixelplay/features/settings/presentation/cache_settings_page.dart';
import 'package:pixelplay/features/settings/presentation/player_settings_page.dart';
import 'package:pixelplay/features/settings/presentation/settings_page.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/thumbnail_queue.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/video_thumbnail_request.dart';

class RecordingThumbnailQueue implements ThumbnailQueue {
  int clearCacheCallCount = 0;

  @override
  void cancel(String cacheKey) {}

  @override
  Future<void> clearCache() async {
    clearCacheCallCount += 1;
  }

  @override
  Future<String> enqueue(VideoThumbnailRequest request, {int priority = 0}) {
    throw UnimplementedError();
  }
}

class RecordingPlaybackPositionRepository
    implements PlaybackPositionRepository {
  int clearAllCallCount = 0;

  @override
  Future<void> clear(String mediaId) async {}

  @override
  Future<void> clearAll() async {
    clearAllCallCount += 1;
  }

  @override
  Future<PlaybackPositionRecord?> load(String mediaId) async {
    return null;
  }

  @override
  Future<void> save(PlaybackPositionRecord record) async {}
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('settings page hides top notice', (WidgetTester tester) async {
    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );

    await tester.pumpWidget(const GetMaterialApp(home: SettingsPage()));
    await tester.pumpAndSettle();

    expect(find.text('主题、动效与播放偏好会自动保存。'), findsNothing);
    expect(find.text('播放器默认设置'), findsOneWidget);
  });

  testWidgets('settings page opens open source licenses page', (
    WidgetTester tester,
  ) async {
    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );

    await tester.pumpWidget(const GetMaterialApp(home: SettingsPage()));
    await tester.pumpAndSettle();

    final licenseFinder = find.text('开源许可证');

    await tester.dragUntilVisible(
      licenseFinder,
      find.byType(ListView).first,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(licenseFinder);
    await tester.pumpAndSettle();

    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.text('Pixel Play'), findsOneWidget);
  });

  testWidgets('player settings page hides top notice', (
    WidgetTester tester,
  ) async {
    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );

    await tester.pumpWidget(const GetMaterialApp(home: PlayerSettingsPage()));
    await tester.pumpAndSettle();

    expect(find.text('这里的配置会作为播放器页面的默认值，并影响手势和播放行为。'), findsNothing);
    expect(find.text('默认倍速'), findsOneWidget);
  });

  testWidgets('cache settings page clears cache after confirmation', (
    WidgetTester tester,
  ) async {
    final thumbnailQueue = RecordingThumbnailQueue();
    final playbackPositionRepository = RecordingPlaybackPositionRepository();

    Get.put<CacheSettingsController>(
      CacheSettingsController(
        cacheCleaner: AppCacheCleaner(
          thumbnailQueue: thumbnailQueue,
          playbackPositionRepository: playbackPositionRepository,
        ),
      ),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        navigatorObservers: <NavigatorObserver>[FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        home: const CacheSettingsPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('UI 骨架阶段：缩略图缓存路径与清理策略尚未接入。'), findsNothing);

    await tester.tap(find.text('清理缓存'));
    await tester.pumpAndSettle();

    expect(find.text('清理缓存？'), findsOneWidget);

    await tester.tap(find.text('清理'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(thumbnailQueue.clearCacheCallCount, 1);
    expect(playbackPositionRepository.clearAllCallCount, 1);
    expect(find.text('缓存已清理'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 200));
  });
}
