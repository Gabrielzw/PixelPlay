import 'package:flutter/widgets.dart';

import 'player_video_metadata.dart';
import 'player_queue_item.dart';

abstract interface class PlayerPlaybackPort {
  Stream<Duration> get positionStream;

  Stream<Duration> get durationStream;

  Stream<bool> get playingStream;

  Stream<bool> get bufferingStream;

  Stream<bool> get completedStream;

  Stream<String> get errorStream;

  Stream<PlayerVideoMetadata> get videoMetadataStream;

  Widget buildVideoView({required BoxFit fit});

  Future<void> open(
    PlayerQueueItem item, {
    required bool play,
    Duration? startPosition,
  });

  Future<void> play();

  Future<void> pause();

  Future<void> seek(Duration position);

  Future<void> setPlaybackSpeed(double speed);

  Future<void> setVolume(double volume);

  Future<void> disposePlayback();
}
