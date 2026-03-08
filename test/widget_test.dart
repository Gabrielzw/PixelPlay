import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'dart:async';

import 'package:pixelplay/app/pixelplay_app.dart';
import 'package:pixelplay/features/media_library/data/in_memory_media_library_repository.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/album_video_preview.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/album_video_tile.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/library_album_card.dart';
import 'package:pixelplay/features/player_core/data/in_memory_playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/player_playback_port.dart';
import 'package:pixelplay/features/player_core/domain/player_queue_item.dart';
import 'package:pixelplay/features/player_core/domain/player_video_metadata.dart';
import 'package:pixelplay/features/player_core/presentation/player_page.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/thumbnail_engine/data/in_memory_thumbnail_queue.dart';
import 'package:pixelplay/features/watch_history/data/in_memory_watch_history_repository.dart';
import 'package:pixelplay/features/watch_history/domain/watch_history_repository.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_account_repository.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_browser_repository.dart';
import 'package:pixelplay/shared/utils/media_formatters.dart';

import 'player_test_device_port.dart';

PixelPlayApp buildTestApp() {
  return PixelPlayApp(
    settingsRepository: InMemorySettingsRepository(),
    mediaLibraryRepository: const InMemoryMediaLibraryRepository(),
    thumbnailQueue: InMemoryThumbnailQueue(),
    playbackPositionRepository: InMemoryPlaybackPositionRepository(),
    watchHistoryRepository: InMemoryWatchHistoryRepository(),
    webDavAccountRepository: InMemoryWebDavAccountRepository(),
    webDavBrowserRepository: const InMemoryWebDavBrowserRepository(),
  );
}

class FakePlayerPlaybackPort implements PlayerPlaybackPort {
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
  Stream<PlayerVideoMetadata> get videoMetadataStream =>
      const Stream<PlayerVideoMetadata>.empty();

  @override
  Stream<bool> get playingStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get positionStream => const Stream<Duration>.empty();

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return const SizedBox.expand();
  }

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

  @override
  Future<Uint8List?> captureScreenshot() async => null;
}

class DeferredReadyPlaybackPort implements PlayerPlaybackPort {
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();

  bool _isReady = false;
  bool? lastOpenPlayValue;
  int playCallCount = 0;
  Duration? lastOpenStartPosition;
  Duration? lastAcceptedSeekPosition;

  @override
  Stream<bool> get bufferingStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get bufferStream => const Stream<Duration>.empty();

  @override
  Stream<bool> get completedStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Stream<String> get errorStream => const Stream<String>.empty();

  @override
  Stream<PlayerVideoMetadata> get videoMetadataStream =>
      const Stream<PlayerVideoMetadata>.empty();

  @override
  Stream<bool> get playingStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return const SizedBox.expand();
  }

  @override
  Future<void> disposePlayback() async {
    await _durationController.close();
    await _positionController.close();
  }

  void emitReady(Duration duration) {
    _isReady = true;
    _durationController.add(duration);
    final startPosition = lastOpenStartPosition;
    if (startPosition != null) {
      lastAcceptedSeekPosition = startPosition;
      _positionController.add(startPosition);
    }
  }

  @override
  Future<void> open(
    PlayerQueueItem item, {
    required bool play,
    Duration? startPosition,
  }) async {
    lastOpenPlayValue = play;
    lastOpenStartPosition = startPosition;
    _durationController.add(Duration.zero);
    _positionController.add(Duration.zero);
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> play() async {
    playCallCount += 1;
  }

  @override
  Future<void> seek(Duration position) async {
    if (!_isReady) {
      return;
    }

    lastAcceptedSeekPosition = position;
    _positionController.add(position);
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<Uint8List?> captureScreenshot() async => null;
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('shows bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('shows local albums from repository', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(
      find.byType(LibraryAlbumCard),
      findsNWidgets(kDemoLocalAlbums.length),
    );
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Download'), findsOneWidget);
  });

  testWidgets('android back pops album to library', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LibraryAlbumCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(LibraryAlbumCard), findsNothing);
    expect(find.text('Screenshots'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(
      find.byType(LibraryAlbumCard),
      findsNWidgets(kDemoLocalAlbums.length),
    );
  });

  testWidgets('shows album videos with preview layout and metadata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LibraryAlbumCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlbumVideoTile), findsWidgets);
    expect(find.byType(AlbumVideoPreview), findsWidgets);
    expect(find.text('Beach Walk.mp4'), findsOneWidget);
    expect(find.textContaining('151 MB'), findsOneWidget);
    expect(
      find.text(
        formatChineseDateTime(
          DateTime.fromMillisecondsSinceEpoch(1_699_999_820 * 1000),
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('player page omits Anime4K action', (WidgetTester tester) async {
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = InMemoryPlaybackPositionRepository();
    final playbackPort = FakePlayerPlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);
    Get.put<WatchHistoryRepository>(InMemoryWatchHistoryRepository());

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          devicePort: TestPlayerDevicePort(),
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'video-1',
              title: 'Test Clip.mp4',
              sourceLabel: '閺堫剙婀?/ Screenshots',
              sourceUri: 'test://video-1',
              duration: Duration(minutes: 10),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    await tester.tapAt(tester.getCenter(find.byType(PlayerPage)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz_rounded), findsOneWidget);
    expect(find.textContaining('Anime4K'), findsNothing);
  });

  testWidgets('player page restores saved playback progress', (
    WidgetTester tester,
  ) async {
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = InMemoryPlaybackPositionRepository();
    final playbackPort = DeferredReadyPlaybackPort();
    await progressRepository.save(
      const PlaybackPositionRecord(
        mediaId: 'video-2',
        positionMs: 120000,
        durationMs: 600000,
      ),
    );

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);
    Get.put<WatchHistoryRepository>(InMemoryWatchHistoryRepository());

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          devicePort: TestPlayerDevicePort(),
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'video-2',
              title: 'Resume.mp4',
              sourceLabel: '閺堫剙婀?/ Camera',
              sourceUri: 'test://video-2',
              duration: const Duration(minutes: 10),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(playbackPort.lastOpenPlayValue, isFalse);
    expect(playbackPort.playCallCount, 1);
    expect(playbackPort.lastOpenStartPosition, const Duration(minutes: 2));
    expect(find.text('02:00'), findsOneWidget);

    playbackPort.emitReady(const Duration(minutes: 10));
    await tester.pump();

    expect(playbackPort.playCallCount, 1);
    expect(playbackPort.lastAcceptedSeekPosition, const Duration(minutes: 2));
    expect(find.text('02:00'), findsOneWidget);
  });
}
