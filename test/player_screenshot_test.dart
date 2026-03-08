import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pixelplay/features/player_core/data/in_memory_playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/player_playback_port.dart';
import 'package:pixelplay/features/player_core/domain/player_queue_item.dart';
import 'package:pixelplay/features/player_core/domain/player_screenshot_store_port.dart';
import 'package:pixelplay/features/player_core/domain/player_video_metadata.dart';
import 'package:pixelplay/features/player_core/presentation/player_page.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';
import 'package:pixelplay/features/watch_history/data/in_memory_watch_history_repository.dart';
import 'package:pixelplay/features/watch_history/domain/watch_history_repository.dart';

import 'player_test_device_port.dart';

class ScreenshotPlaybackPort implements PlayerPlaybackPort {
  final Uint8List screenshotBytes = Uint8List.fromList(<int>[1, 2, 3]);

  @override
  Stream<bool> get bufferingStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get bufferStream => const Stream<Duration>.empty();

  @override
  Stream<bool> get completedStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get durationStream => const Stream<Duration>.empty();

  @override
  Stream<String> get errorStream => const Stream<String>.empty();

  @override
  Stream<bool> get playingStream => Stream<bool>.value(true);

  @override
  Stream<Duration> get positionStream => const Stream<Duration>.empty();

  @override
  Stream<PlayerVideoMetadata> get videoMetadataStream =>
      const Stream<PlayerVideoMetadata>.empty();

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return const SizedBox.expand();
  }

  @override
  Future<Uint8List?> captureScreenshot() async => screenshotBytes;

  @override
  Future<void> disposePlayback() async {}

  @override
  Future<void> open(
    PlayerQueueItem item, {
    required bool play,
    Duration? startPosition,
  }) async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> play() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> setPlaybackSpeed(double speed) async {}

  @override
  Future<void> setVolume(double volume) async {}
}

class FakePlayerScreenshotStore implements PlayerScreenshotStorePort {
  final Completer<String> completer = Completer<String>();
  Uint8List? savedBytes;
  int saveCallCount = 0;

  @override
  Future<String> saveScreenshot(Uint8List bytes) {
    saveCallCount += 1;
    savedBytes = bytes;
    return completer.future;
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('截图进行中显示加载动画并在完成后提示成功', (WidgetTester tester) async {
    final playbackPort = ScreenshotPlaybackPort();
    final screenshotStore = FakePlayerScreenshotStore();

    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );
    Get.put<PlaybackPositionRepository>(InMemoryPlaybackPositionRepository());
    Get.put<WatchHistoryRepository>(InMemoryWatchHistoryRepository());

    await tester.pumpWidget(
      GetMaterialApp(
        navigatorObservers: <NavigatorObserver>[FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        home: PlayerPage(
          playbackPort: playbackPort,
          devicePort: TestPlayerDevicePort(),
          screenshotStore: screenshotStore,
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'video-screenshot',
              title: 'Screenshot Video.mp4',
              sourceLabel: 'WebDAV / Test',
              sourceUri: 'test://video-screenshot',
            ),
          ],
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tapAt(tester.getCenter(find.byType(PlayerPage)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.photo_camera_outlined));
    await tester.pump();

    expect(screenshotStore.saveCallCount, 1);
    expect(screenshotStore.savedBytes, playbackPort.screenshotBytes);
    expect(find.byIcon(Icons.photo_camera_outlined), findsNothing);
    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget.runtimeType.toString() == 'ThreeArchedCircle',
      ),
      findsOneWidget,
    );

    screenshotStore.completer.complete('content://pixelplay/screenshot/1');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.text('截图成功，已保存到 Pictures/PixelPlay'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 200));
  });
}
