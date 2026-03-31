import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/favorites/data/in_memory_favorites_repository.dart';
import 'package:pixelplay/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:pixelplay/features/player_core/data/in_memory_playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/player_controller.dart';
import 'package:pixelplay/features/player_core/domain/player_device_port.dart';
import 'package:pixelplay/features/player_core/domain/player_playback_port.dart';
import 'package:pixelplay/features/player_core/domain/player_queue_item.dart';
import 'package:pixelplay/features/player_core/domain/player_screenshot_store_port.dart';
import 'package:pixelplay/features/player_core/domain/player_video_metadata.dart';
import 'package:pixelplay/features/player_core/presentation/widgets/player_control_actions.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';
import 'package:pixelplay/features/watch_history/data/in_memory_watch_history_repository.dart';

void main() {
  testWidgets('favorite button changes when current video becomes favorited', (
    WidgetTester tester,
  ) async {
    final favoritesController = FavoritesController(
      repository: InMemoryFavoritesRepository(),
    );
    favoritesController.refreshFolders();
    final controller = PlayerController(
      settingsController: SettingsController(
        repository: InMemorySettingsRepository(),
      ),
      playbackPositionRepository: InMemoryPlaybackPositionRepository(),
      watchHistoryRepository: InMemoryWatchHistoryRepository(),
      playbackPort: _FakePlaybackPort(),
      devicePort: _FakeDevicePort(),
      screenshotStore: _FakeScreenshotStorePort(),
      queue: <PlayerQueueItem>[_buildQueueItem()],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlayerControlActions(
            controller: controller,
            favoritesController: favoritesController,
            onBack: () {},
            onShowFavorite: () {},
            onShowMore: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byTooltip('收藏'), findsOneWidget);

    favoritesController.addQueueItemToFolders(
      item: _buildQueueItem(),
      folderIds: <String>{'default-favorites'},
    );
    await tester.pump();

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byTooltip('已收藏'), findsOneWidget);
  });
}

PlayerQueueItem _buildQueueItem() {
  return PlayerQueueItem(
    id: 'video-1',
    title: 'Test Clip.mp4',
    sourceLabel: 'Camera',
    path: '/storage/emulated/0/DCIM/Test Clip.mp4',
    duration: const Duration(minutes: 3, seconds: 25),
    localVideoId: 1,
    localVideoDateModified: 123,
  );
}

class _FakePlaybackPort implements PlayerPlaybackPort {
  @override
  Stream<Duration> get bufferStream => const Stream<Duration>.empty();

  @override
  Stream<bool> get bufferingStream => const Stream<bool>.empty();

  @override
  Stream<bool> get completedStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get durationStream => const Stream<Duration>.empty();

  @override
  Stream<String> get errorStream => const Stream<String>.empty();

  @override
  Stream<bool> get playingStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get positionStream => const Stream<Duration>.empty();

  @override
  Stream<PlayerVideoMetadata> get videoMetadataStream =>
      const Stream<PlayerVideoMetadata>.empty();

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return const SizedBox.shrink();
  }

  @override
  Future<Uint8List?> captureScreenshot() async => null;

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

class _FakeDevicePort implements PlayerDevicePort {
  @override
  Future<void> attach() async {}

  @override
  Future<void> detach() async {}

  @override
  Future<PlayerDeviceSnapshot> loadSnapshot() async {
    return const PlayerDeviceSnapshot(
      brightnessLevel: 0.5,
      volumeLevel: 0.5,
      timeText: '12:00',
      networkStatus: PlayerNetworkStatus.wifi,
      batteryInfo: PlayerBatteryInfo(level: 100, isCharging: false),
    );
  }

  @override
  Future<void> setBrightness(double brightness) async {}

  @override
  Future<void> setPlaybackOrientation(
    PlayerVideoOrientation orientation,
  ) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Stream<PlayerBatteryInfo> watchBattery() =>
      const Stream<PlayerBatteryInfo>.empty();

  @override
  Stream<double> watchBrightness() => const Stream<double>.empty();

  @override
  Stream<String> watchClock() => const Stream<String>.empty();

  @override
  Stream<PlayerNetworkStatus> watchNetwork() =>
      const Stream<PlayerNetworkStatus>.empty();

  @override
  Stream<double> watchVolume() => const Stream<double>.empty();
}

class _FakeScreenshotStorePort implements PlayerScreenshotStorePort {
  @override
  Future<String> saveScreenshot(Uint8List bytes) async {
    return '/tmp/screenshot.png';
  }
}
