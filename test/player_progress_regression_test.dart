import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pixelplay/features/player_core/domain/playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/player_playback_port.dart';
import 'package:pixelplay/features/player_core/domain/player_queue_item.dart';
import 'package:pixelplay/features/player_core/domain/player_video_metadata.dart';
import 'package:pixelplay/features/player_core/presentation/player_page.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';

import 'player_test_device_port.dart';

class RecordingPlaybackPositionRepository
    implements PlaybackPositionRepository {
  PlaybackPositionRecord? savedRecord;

  @override
  Future<PlaybackPositionRecord?> load(String mediaId) async {
    return savedRecord;
  }

  @override
  Future<void> save(PlaybackPositionRecord record) async {
    savedRecord = record;
  }

  @override
  Future<void> clear(String mediaId) async {
    savedRecord = null;
  }
}

class RegressionPlaybackPort implements PlayerPlaybackPort {
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

  bool? lastOpenPlayValue;
  int playCallCount = 0;
  Duration? lastOpenStartPosition;
  Duration? lastSeekPosition;
  Completer<void>? openCompleter;
  bool _isDisposed = false;

  @override
  Stream<bool> get bufferingStream => _bufferingController.stream;

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
    _isDisposed = true;
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
    lastOpenPlayValue = play;
    lastOpenStartPosition = startPosition;
    final pendingOpen = openCompleter;
    if (pendingOpen != null) {
      await pendingOpen.future;
    }
    if (_isDisposed) {
      return;
    }
    _playingController.add(play);
  }

  @override
  Future<void> pause() async {
    _playingController.add(false);
  }

  @override
  Future<void> play() async {
    playCallCount += 1;
    _playingController.add(true);
  }

  @override
  Future<void> seek(Duration position) async {
    lastSeekPosition = position;
    _positionController.add(position);
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {}

  @override
  Future<void> setVolume(double volume) async {}
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('player page saves latest observed position before popping', (
    WidgetTester tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = RecordingPlaybackPositionRepository();
    final playbackPort = RegressionPlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);

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
                              id: 'video-latest',
                              title: 'Latest Position.mp4',
                              sourceLabel: '本地 / Camera',
                              sourceUri: 'test://video-latest',
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

    playbackPort.emitPosition(const Duration(minutes: 2, milliseconds: 500));
    await tester.pump();

    await navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();

    expect(progressRepository.savedRecord?.mediaId, 'video-latest');
    expect(progressRepository.savedRecord?.positionMs, 120500);
    expect(progressRepository.savedRecord?.durationMs, 600000);
  });

  testWidgets('player page saves progress when app goes to background', (
    WidgetTester tester,
  ) async {
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = RecordingPlaybackPositionRepository();
    final playbackPort = RegressionPlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          devicePort: TestPlayerDevicePort(),
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'video-background',
              title: 'Background Save.mp4',
              sourceLabel: '本地 / Camera',
              sourceUri: 'test://video-background',
              duration: const Duration(minutes: 10),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    playbackPort.emitDuration(const Duration(minutes: 10));
    playbackPort.emitPosition(const Duration(minutes: 2, seconds: 30));
    await tester.pump();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();

    expect(progressRepository.savedRecord?.mediaId, 'video-background');
    expect(progressRepository.savedRecord?.positionMs, 150000);
    expect(progressRepository.savedRecord?.durationMs, 600000);
  });

  testWidgets('player page keeps saved progress when exiting during restore', (
    WidgetTester tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = RecordingPlaybackPositionRepository()
      ..savedRecord = const PlaybackPositionRecord(
        mediaId: 'video-race',
        positionMs: 120000,
        durationMs: 600000,
      );
    final playbackPort = RegressionPlaybackPort()
      ..openCompleter = Completer<void>();

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);

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
                              id: 'video-race',
                              title: 'Restore Race.mp4',
                              sourceLabel: '本地 / Camera',
                              sourceUri: 'test://video-race',
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

    expect(progressRepository.savedRecord?.mediaId, 'video-race');
    expect(progressRepository.savedRecord?.positionMs, 120000);
    expect(progressRepository.savedRecord?.durationMs, 600000);
  });

  testWidgets('player page restores saved progress near the start', (
    WidgetTester tester,
  ) async {
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = RecordingPlaybackPositionRepository()
      ..savedRecord = const PlaybackPositionRecord(
        mediaId: 'video-near-start',
        positionMs: 3000,
        durationMs: 600000,
      );
    final playbackPort = RegressionPlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          devicePort: TestPlayerDevicePort(),
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'video-near-start',
              title: 'Near Start Resume.mp4',
              sourceLabel: '本地 / Camera',
              sourceUri: 'test://video-near-start',
              duration: const Duration(minutes: 10),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(playbackPort.lastOpenPlayValue, isFalse);
    expect(playbackPort.playCallCount, 1);
    expect(playbackPort.lastOpenStartPosition, const Duration(seconds: 3));
    expect(playbackPort.lastSeekPosition, isNull);

    playbackPort.emitDuration(const Duration(minutes: 10));
    await tester.pump();

    expect(playbackPort.playCallCount, 1);
  });
}
