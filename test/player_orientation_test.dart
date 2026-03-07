import 'dart:async';

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

import 'player_test_device_port.dart';

class OrientationPlaybackPort implements PlayerPlaybackPort {
  final StreamController<bool> _playingController =
      StreamController<bool>.broadcast();
  final StreamController<PlayerVideoMetadata> _videoMetadataController =
      StreamController<PlayerVideoMetadata>.broadcast();

  @override
  Stream<bool> get bufferingStream => const Stream<bool>.empty();

  @override
  Stream<bool> get completedStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get durationStream => const Stream<Duration>.empty();

  @override
  Stream<String> get errorStream => const Stream<String>.empty();

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<Duration> get positionStream => const Stream<Duration>.empty();

  @override
  Stream<PlayerVideoMetadata> get videoMetadataStream =>
      _videoMetadataController.stream;

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return const SizedBox.expand();
  }

  @override
  Future<void> disposePlayback() async {
    await _playingController.close();
    await _videoMetadataController.close();
  }

  void emitVideoMetadata(PlayerVideoMetadata value) {
    _videoMetadataController.add(value);
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
  Future<void> seek(Duration position) async {}

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

  testWidgets('player locks orientation from rotated video metadata', (
    WidgetTester tester,
  ) async {
    final playbackPort = OrientationPlaybackPort();
    final devicePort = TestPlayerDevicePort();

    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );
    Get.put<PlaybackPositionRepository>(InMemoryPlaybackPositionRepository());

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          devicePort: devicePort,
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'video-rotation',
              title: 'Rotation Video.mp4',
              sourceLabel: 'WebDAV / Test',
              sourceUri: 'test://video-rotation',
            ),
          ],
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(devicePort.playbackOrientation, PlayerVideoOrientation.unknown);

    playbackPort.emitVideoMetadata(
      const PlayerVideoMetadata(width: 1920, height: 1080, rotationDegrees: 90),
    );
    await tester.pump();

    expect(devicePort.playbackOrientation, PlayerVideoOrientation.portrait);

    playbackPort.emitVideoMetadata(
      const PlayerVideoMetadata(width: 1080, height: 1920, rotationDegrees: 90),
    );
    await tester.pump();

    expect(devicePort.playbackOrientation, PlayerVideoOrientation.landscape);
  });
}
