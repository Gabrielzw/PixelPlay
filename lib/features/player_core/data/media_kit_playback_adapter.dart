import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../domain/player_playback_port.dart';
import '../domain/player_queue_item.dart';

const int kPlaybackBufferBytes = 48 * 1024 * 1024;
const String kPlaybackTitle = 'PixelPlay';

class MediaKitPlaybackAdapter implements PlayerPlaybackPort {
  final Player player;
  final VideoController videoController;

  MediaKitPlaybackAdapter._({
    required this.player,
    required this.videoController,
  });

  factory MediaKitPlaybackAdapter({
    Player? player,
    VideoController? videoController,
  }) {
    final resolvedPlayer = player ?? _buildPlayer();
    final resolvedVideoController =
        videoController ?? _buildVideoController(resolvedPlayer);
    return MediaKitPlaybackAdapter._(
      player: resolvedPlayer,
      videoController: resolvedVideoController,
    );
  }

  @override
  Stream<Duration> get positionStream => player.stream.position;

  @override
  Stream<Duration> get durationStream => player.stream.duration;

  @override
  Stream<bool> get playingStream => player.stream.playing;

  @override
  Stream<bool> get bufferingStream => player.stream.buffering;

  @override
  Stream<bool> get completedStream => player.stream.completed;

  @override
  Stream<String> get errorStream => player.stream.error;

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return RepaintBoundary(
      child: Video(
        controller: videoController,
        fit: fit,
        controls: NoVideoControls,
        filterQuality: FilterQuality.low,
        pauseUponEnteringBackgroundMode: true,
        resumeUponEnteringForegroundMode: false,
        wakelock: true,
      ),
    );
  }

  @override
  Future<void> open(PlayerQueueItem item, {required bool play}) async {
    final source = item.playbackUri;
    if (source == null || source.trim().isEmpty) {
      throw StateError('Missing playback source for media id: ${item.id}');
    }

    final headers = item.httpHeaders.isEmpty ? null : item.httpHeaders;
    await player.open(Media(source, httpHeaders: headers), play: play);
  }

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> play() => player.play();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> setPlaybackSpeed(double speed) => player.setRate(speed);

  @override
  Future<void> setVolume(double volume) => player.setVolume(volume * 100);

  @override
  Future<void> disposePlayback() => player.dispose();
}

Player _buildPlayer() {
  return Player(
    configuration: const PlayerConfiguration(
      title: kPlaybackTitle,
      osc: false,
      bufferSize: kPlaybackBufferBytes,
      logLevel: MPVLogLevel.error,
    ),
  );
}

VideoController _buildVideoController(Player player) {
  return VideoController(
    player,
    configuration: const VideoControllerConfiguration(
      enableHardwareAcceleration: true,
      androidAttachSurfaceAfterVideoParameters: true,
    ),
  );
}
