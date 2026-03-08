import 'dart:async';
import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pixelplay/features/player_core/data/in_memory_playback_position_repository.dart';
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

class BufferingPlaybackPort implements PlayerPlaybackPort {
  final StreamController<Duration> _bufferController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<bool> _playingController =
      StreamController<bool>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();

  @override
  Stream<bool> get bufferingStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get bufferStream => _bufferController.stream;

  @override
  Stream<bool> get completedStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Stream<String> get errorStream => const Stream<String>.empty();

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<PlayerVideoMetadata> get videoMetadataStream =>
      const Stream<PlayerVideoMetadata>.empty();

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return const SizedBox.expand();
  }

  @override
  Future<void> disposePlayback() async {
    await _bufferController.close();
    await _durationController.close();
    await _playingController.close();
    await _positionController.close();
  }

  void emitBuffer(Duration value) {
    _bufferController.add(value);
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
  });

  testWidgets('remote player progress bar shows buffered progress', (
    WidgetTester tester,
  ) async {
    final playbackPort = BufferingPlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );
    Get.put<PlaybackPositionRepository>(InMemoryPlaybackPositionRepository());
    Get.put<WatchHistoryRepository>(InMemoryWatchHistoryRepository());

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          devicePort: TestPlayerDevicePort(),
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'https://example.com/video.mp4',
              title: 'video.mp4',
              sourceLabel: '?? / example.com',
              sourceUri: 'https://example.com/video.mp4',
              sourceKind: MediaSourceKind.other,
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    playbackPort.emitDuration(const Duration(minutes: 10));
    playbackPort.emitPosition(const Duration(minutes: 2));
    playbackPort.emitBuffer(const Duration(minutes: 4));
    await tester.pump();

    final progressBar = tester.widget<ProgressBar>(find.byType(ProgressBar));
    expect(progressBar.progress, const Duration(minutes: 2));
    expect(progressBar.buffered, const Duration(minutes: 4));
    expect(progressBar.total, const Duration(minutes: 10));
  });

  testWidgets('local player progress bar does not show buffered progress', (
    WidgetTester tester,
  ) async {
    final playbackPort = BufferingPlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );
    Get.put<PlaybackPositionRepository>(InMemoryPlaybackPositionRepository());
    Get.put<WatchHistoryRepository>(InMemoryWatchHistoryRepository());

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          devicePort: TestPlayerDevicePort(),
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'local-video',
              title: 'local.mp4',
              sourceLabel: '?? / Camera',
              path: 'file:///local.mp4',
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    playbackPort.emitDuration(const Duration(minutes: 5));
    playbackPort.emitPosition(const Duration(minutes: 1));
    playbackPort.emitBuffer(const Duration(minutes: 3));
    await tester.pump();

    final progressBar = tester.widget<ProgressBar>(find.byType(ProgressBar));
    expect(progressBar.progress, const Duration(minutes: 1));
    expect(progressBar.buffered, isNull);
    expect(progressBar.total, const Duration(minutes: 5));
  });
}
