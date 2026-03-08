import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../domain/player_playback_port.dart';
import '../domain/player_queue_item.dart';
import '../domain/player_video_metadata.dart';

const int kPlaybackBufferBytes = 48 * 1024 * 1024;
const String kPlaybackTitle = 'PixelPlay';
const String kPlaybackAutoSyncProperty = 'autosync';
const int kPlaybackAutoSyncValue = 30;

class MediaKitPlaybackAdapter implements PlayerPlaybackPort {
  final Player player;
  final VideoController videoController;
  Future<void>? _nativePlayerConfiguration;

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
  Stream<PlayerVideoMetadata> get videoMetadataStream =>
      player.stream.videoParams.map(_mapVideoMetadata).distinct();

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
  Future<void> open(
    PlayerQueueItem item, {
    required bool play,
    Duration? startPosition,
  }) async {
    await _ensureNativePlayerConfigured();

    final source = item.playbackUri;
    if (source == null || source.trim().isEmpty) {
      throw StateError('Missing playback source for media id: ${item.id}');
    }

    final headers = item.httpHeaders.isEmpty ? null : item.httpHeaders;
    await player.open(
      Media(source, start: startPosition, httpHeaders: headers),
      play: play,
    );
  }

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> play() => player.play();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    await _ensureNativePlayerConfigured();
    await player.setRate(speed);
  }

  @override
  Future<void> setVolume(double volume) => player.setVolume(volume * 100);

  @override
  Future<Uint8List?> captureScreenshot() {
    return player.screenshot(format: 'image/png');
  }

  @override
  Future<void> disposePlayback() => player.dispose();

  Future<void> _ensureNativePlayerConfigured() {
    return _nativePlayerConfiguration ??= _configureNativePlayer(player);
  }
}

Future<void> _configureNativePlayer(Player player) async {
  final platform = player.platform;
  if (platform is! NativePlayer) {
    return;
  }

  await platform.setProperty(
    kPlaybackAutoSyncProperty,
    kPlaybackAutoSyncValue.toString(),
  );
}

Player _buildPlayer() {
  return Player(
    configuration: const PlayerConfiguration(
      // title: kPlaybackTitle,
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

PlayerVideoMetadata _mapVideoMetadata(VideoParams params) {
  return PlayerVideoMetadata(
    width: params.dw ?? params.w,
    height: params.dh ?? params.h,
    rotationDegrees: params.rotate ?? 0,
  );
}
