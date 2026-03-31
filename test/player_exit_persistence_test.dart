import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pixelplay/features/favorites/data/in_memory_favorites_repository.dart';
import 'package:pixelplay/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:pixelplay/features/player_core/domain/playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/player_playback_port.dart';
import 'package:pixelplay/features/player_core/domain/player_queue_item.dart';
import 'package:pixelplay/features/player_core/domain/player_video_metadata.dart';
import 'package:pixelplay/features/player_core/presentation/player_page.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';
import 'package:pixelplay/features/watch_history/data/in_memory_watch_history_repository.dart';
import 'package:pixelplay/features/watch_history/domain/watch_history_repository.dart';
import 'package:pixelplay/shared/domain/media_source_kind.dart';

import 'player_test_device_port.dart';

class DelayedPlaybackPositionRepository implements PlaybackPositionRepository {
  final Completer<void> saveCompleter = Completer<void>();

  PlaybackPositionRecord? savedRecord;

  @override
  Future<PlaybackPositionRecord?> load(String mediaId) async {
    return savedRecord;
  }

  @override
  Future<void> save(PlaybackPositionRecord record) async {
    savedRecord = record;
    await saveCompleter.future;
  }

  @override
  Future<void> clear(String mediaId) async {
    savedRecord = null;
  }

  @override
  Future<void> clearAll() async {
    savedRecord = null;
  }
}

class ControllablePlaybackPort implements PlayerPlaybackPort {
  final StreamController<bool> _bufferingController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _completedController =
      StreamController<bool>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();
  final StreamController<bool> _playingController =
      StreamController<bool>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();

  @override
  Stream<bool> get bufferingStream => _bufferingController.stream;

  @override
  Stream<Duration> get bufferStream => const Stream<Duration>.empty();

  @override
  Stream<bool> get completedStream => _completedController.stream;

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Stream<String> get errorStream => _errorController.stream;

  @override
  Stream<PlayerVideoMetadata> get videoMetadataStream =>
      const Stream<PlayerVideoMetadata>.empty();

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return const SizedBox.expand();
  }

  @override
  Future<void> disposePlayback() async {
    await _bufferingController.close();
    await _completedController.close();
    await _durationController.close();
    await _errorController.close();
    await _playingController.close();
    await _positionController.close();
  }

  void emitDuration(Duration value) {
    _durationController.add(value);
  }

  void emitPosition(Duration value) {
    _positionController.add(value);
  }

  @override
  Future<void> open(
    PlayerQueueItem item, {
    required bool play,
    Duration? startPosition,
  }) async {
    _playingController.add(play);
  }

  @override
  Future<void> pause() async {
    _playingController.add(false);
  }

  @override
  Future<void> play() async {
    _playingController.add(true);
  }

  @override
  Future<void> seek(Duration position) async {
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
    Get.put<FavoritesController>(
      FavoritesController(repository: InMemoryFavoritesRepository()),
    );
  });

  testWidgets('player page waits for progress save before popping', (
    WidgetTester tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = DelayedPlaybackPositionRepository();
    final playbackPort = ControllablePlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);
    Get.put<WatchHistoryRepository>(InMemoryWatchHistoryRepository());

    await tester.pumpWidget(
      GetMaterialApp(
        navigatorKey: navigatorKey,
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PlayerPage(
                          playbackPort: playbackPort,
                          devicePort: TestPlayerDevicePort(),
                          playlist: <PlayerQueueItem>[
                            PlayerQueueItem(
                              id: 'video-exit',
                              title: 'Exit Resume.mp4',
                              sourceLabel: '本地 / Camera',
                              sourceUri: 'test://video-exit',
                              duration: const Duration(minutes: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('open player'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open player'));
    await tester.pump();
    await tester.pump();

    playbackPort.emitDuration(const Duration(minutes: 10));
    playbackPort.emitPosition(const Duration(minutes: 2));
    await tester.pump();

    final Future<bool> popFuture = navigatorKey.currentState!.maybePop();
    await tester.pump();

    expect(find.byType(PlayerPage), findsOneWidget);
    expect(progressRepository.savedRecord?.mediaId, 'video-exit');
    expect(progressRepository.savedRecord?.positionMs, 120000);
    expect(progressRepository.savedRecord?.durationMs, 600000);

    progressRepository.saveCompleter.complete();
    await popFuture;
    await tester.pumpAndSettle();

    expect(find.byType(PlayerPage), findsNothing);
    expect(find.text('open player'), findsOneWidget);
  });

  testWidgets('player page leaves watch history when exited immediately', (
    WidgetTester tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = DelayedPlaybackPositionRepository();
    final historyRepository = InMemoryWatchHistoryRepository();
    final playbackPort = ControllablePlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);
    Get.put<WatchHistoryRepository>(historyRepository);

    await tester.pumpWidget(
      GetMaterialApp(
        navigatorKey: navigatorKey,
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PlayerPage(
                          playbackPort: playbackPort,
                          devicePort: TestPlayerDevicePort(),
                          playlist: <PlayerQueueItem>[
                            PlayerQueueItem(
                              id: 'video-history',
                              title: 'History.mp4',
                              sourceLabel: '本地 / Camera',
                              sourceUri: 'test://video-history',
                              duration: const Duration(minutes: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('open player'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open player'));
    await tester.pump();
    await tester.pump();

    await navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();

    final record = await historyRepository.load('video-history');
    expect(record, isNotNull);
    expect(record?.title, 'History.mp4');
    expect(record?.positionMs, 0);
    expect(record?.durationMs, 600000);
  });

  testWidgets('player page saves other source watch history with source url', (
    WidgetTester tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = DelayedPlaybackPositionRepository();
    final historyRepository = InMemoryWatchHistoryRepository();
    final playbackPort = ControllablePlaybackPort();
    const sourceUrl = 'https://example.com/media/trailer.mp4';

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);
    Get.put<WatchHistoryRepository>(historyRepository);

    await tester.pumpWidget(
      GetMaterialApp(
        navigatorKey: navigatorKey,
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PlayerPage(
                          playbackPort: playbackPort,
                          devicePort: TestPlayerDevicePort(),
                          playlist: <PlayerQueueItem>[
                            PlayerQueueItem(
                              id: sourceUrl,
                              title: 'trailer.mp4',
                              sourceLabel: '\u5176\u4ed6 / example.com',
                              sourceUri: sourceUrl,
                              sourceKind: MediaSourceKind.other,
                              duration: const Duration(minutes: 3),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('open other player'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open other player'));
    await tester.pump();
    await tester.pump();

    playbackPort.emitDuration(const Duration(minutes: 3));
    playbackPort.emitPosition(const Duration(seconds: 40));
    await tester.pump();

    await navigatorKey.currentState!.maybePop();
    progressRepository.saveCompleter.complete();
    await tester.pumpAndSettle();

    final record = await historyRepository.load(sourceUrl);
    expect(record, isNotNull);
    expect(record?.sourceKind, MediaSourceKind.other);
    expect(record?.sourceUri, sourceUrl);
    expect(record?.mediaPath, isNull);
    expect(record?.positionMs, 40000);
    expect(record?.durationMs, 180000);
  });
}
