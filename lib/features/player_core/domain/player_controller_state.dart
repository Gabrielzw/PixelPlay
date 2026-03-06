part of 'player_controller.dart';

const double kPlaybackRestoreMinRatio = 0.05;
const double kPlaybackRestoreMaxRatio = 0.95;
const double kGestureDefaultLevel = 0.6;
const double kGestureDecisionSlop = 12;

const Duration kControlsAutoHideDelay = Duration(seconds: 3);
const Duration kGestureHudHideDelay = Duration(seconds: 1);
const Duration kProgressSaveDebounce = Duration(milliseconds: 400);
const Duration kPlaybackPositionSyncInterval = Duration(milliseconds: 250);
const Duration kPlaybackPositionJumpThreshold = Duration(seconds: 1);

const String kPlayerDecodeErrorMessage = '视频解码失败，格式可能不受支持。';
const String kPlayerNetworkErrorMessage = '网络连接异常，请检查网络或 WebDAV 服务状态。';
const String kPlayerPlaybackErrorPrefix = '播放失败：';
const String kPlayerMissingSourceMessage = '当前媒体没有可播放地址。';

const List<PlayerAspectRatio> kAspectRatioCycleOrder = <PlayerAspectRatio>[
  PlayerAspectRatio.fit,
  PlayerAspectRatio.fill,
  PlayerAspectRatio.original,
  PlayerAspectRatio.crop,
];

enum PlayerHudKind { brightness, volume, seek, info }

@immutable
class PlayerHudState {
  final PlayerHudKind kind;
  final String primaryText;
  final Alignment alignment;

  const PlayerHudState({
    required this.kind,
    required this.primaryText,
    this.alignment = Alignment.center,
  });
}

enum _PlayerGestureMode { pending, none, seek, brightness, volume }

class _PlayerGestureSession {
  final Offset startOffset;
  final Size viewportSize;
  final Duration basePosition;
  final double baseBrightness;
  final double baseVolume;
  _PlayerGestureMode mode = _PlayerGestureMode.pending;

  _PlayerGestureSession({
    required this.startOffset,
    required this.viewportSize,
    required this.basePosition,
    required this.baseBrightness,
    required this.baseVolume,
  });
}
