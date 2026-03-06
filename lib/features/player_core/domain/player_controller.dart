import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../settings/domain/app_settings.dart';
import '../../settings/domain/settings_controller.dart';
import 'playback_position_repository.dart';
import 'player_playback_port.dart';
import 'player_queue_item.dart';

part 'player_controller_state.dart';
part 'player_controller_gestures.dart';
part 'player_controller_playback.dart';

class PlayerController extends GetxController {
  final SettingsController settingsController;
  final PlaybackPositionRepository playbackPositionRepository;
  final PlayerPlaybackPort playbackPort;
  final List<PlayerQueueItem> queue;

  final RxBool isPlaying = true.obs;
  final RxBool controlsVisible = true.obs;
  final RxBool controlsLocked = false.obs;
  final RxBool isBuffering = false.obs;
  final RxDouble progress = 0.0.obs;
  final RxDouble brightnessLevel = kGestureDefaultLevel.obs;
  final RxDouble volumeLevel = kGestureDefaultLevel.obs;
  final RxDouble playbackSpeed = 1.0.obs;
  final RxInt currentIndex = 0.obs;
  final Rxn<PlayerHudState> hudState = Rxn<PlayerHudState>();
  final RxnString errorMessage = RxnString();

  late final Rx<PlayerQueueItem> currentItem;
  late final Rx<Duration> position;
  late final Rx<Duration> duration;
  late final Rx<PlayerAspectRatio> aspectRatio;

  final List<StreamSubscription<Object?>> _playbackSubscriptions =
      <StreamSubscription<Object?>>[];

  Timer? _controlsTimer;
  Timer? _hudTimer;
  Timer? _progressSaveTimer;
  _PlayerGestureSession? _gestureSession;
  Duration? _pendingSeekPosition;
  DateTime? _lastPositionSyncAt;
  Duration _lastSyncedPosition = Duration.zero;

  PlayerController({
    required this.settingsController,
    required this.playbackPositionRepository,
    required this.playbackPort,
    required List<PlayerQueueItem> queue,
    int initialIndex = 0,
  }) : queue = List<PlayerQueueItem>.unmodifiable(queue) {
    if (this.queue.isEmpty) {
      throw ArgumentError.value(
        queue,
        'queue',
        'Player queue must not be empty.',
      );
    }

    final safeIndex = initialIndex.clamp(0, this.queue.length - 1);
    final initialItem = this.queue[safeIndex];
    final settings = settingsController.settings.value;

    currentIndex.value = safeIndex;
    currentItem = initialItem.obs;
    position = Duration.zero.obs;
    duration = initialItem.duration.obs;
    aspectRatio = settings.defaultAspectRatio.obs;
    playbackSpeed.value = settings.defaultPlaybackSpeed;
  }

  bool get hasPrevious => currentIndex.value > 0;

  bool get hasNext => currentIndex.value < queue.length - 1;

  bool get hasKnownDuration => duration.value > Duration.zero;

  bool get isNetworkError => currentItem.value.isRemote;

  @override
  Future<void> onReady() async {
    super.onReady();
    _bindPlaybackStreams();
    await _syncPlaybackPreferences();
    await openCurrentItem(restoreProgress: true, showRestoreMessage: true);
    armControlsAutoHide();
  }

  @override
  void onClose() {
    unawaited(persistCurrentProgress());
    _controlsTimer?.cancel();
    _hudTimer?.cancel();
    _progressSaveTimer?.cancel();
    for (final subscription in _playbackSubscriptions) {
      subscription.cancel();
    }
    super.onClose();
  }

  void handleSurfaceTap() {
    if (controlsLocked.value) {
      return;
    }
    if (controlsVisible.value) {
      hideControls();
      return;
    }
    showControls();
  }

  Future<void> togglePlay() async {
    if (isPlaying.value) {
      await playbackPort.pause();
      showControls();
      cancelControlsAutoHide();
      return;
    }

    clearError();
    await playbackPort.play();
    armControlsAutoHide();
  }

  void toggleLock() {
    if (controlsLocked.value) {
      controlsLocked.value = false;
      showControls();
      showInfoHud('已解锁屏幕');
      armControlsAutoHide();
      return;
    }

    controlsLocked.value = true;
    controlsVisible.value = false;
    cancelControlsAutoHide();
    showInfoHud('已锁定屏幕');
  }

  Future<void> playPrevious() async {
    if (!hasPrevious) {
      return;
    }
    await switchToIndex(currentIndex.value - 1);
  }

  Future<void> playNext() async {
    if (!hasNext) {
      return;
    }
    await switchToIndex(currentIndex.value + 1);
  }

  Future<void> handlePlaybackCompleted() async {
    await playbackPositionRepository.clear(currentItem.value.id);
    if (!settingsController.settings.value.autoPlayNext || !hasNext) {
      applyPosition(duration.value);
      showControls();
      return;
    }
    await playNext();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeed.value = speed;
    await playbackPort.setPlaybackSpeed(speed);
    await settingsController.setDefaultPlaybackSpeed(speed);
    showInfoHud('播放速度 ${speed}x');
    armControlsAutoHide();
  }

  Future<void> cycleAspectRatio() async {
    final current = aspectRatio.value;
    final index = kAspectRatioCycleOrder.indexOf(current);
    final next =
        kAspectRatioCycleOrder[(index + 1) % kAspectRatioCycleOrder.length];
    await setAspectRatio(next);
  }

  Future<void> setAspectRatio(PlayerAspectRatio value) async {
    aspectRatio.value = value;
    await settingsController.setDefaultAspectRatio(value);
    showInfoHud(value.label);
    armControlsAutoHide();
  }

  void beginSeekPreview() {
    cancelControlsAutoHide();
  }

  void previewSeekToRatio(double value) {
    if (!hasKnownDuration) {
      return;
    }

    final safeValue = value.clamp(0.0, 1.0);
    final nextPosition = Duration(
      milliseconds: (duration.value.inMilliseconds * safeValue).round(),
    );
    previewSeekPosition(nextPosition);
  }

  Future<void> commitSeekPreview() async {
    final pendingPosition = _pendingSeekPosition;
    if (pendingPosition == null) {
      armControlsAutoHide();
      return;
    }

    await playbackPort.seek(pendingPosition);
    _pendingSeekPosition = null;
    scheduleProgressSave();
    armControlsAutoHide();
  }

  Future<void> resetCurrentProgress() async {
    await playbackPositionRepository.clear(currentItem.value.id);
    previewSeekPosition(Duration.zero);
    await commitSeekPreview();
    showInfoHud('已清除当前播放进度');
  }

  void showScreenshotUnavailable() {
    showInfoHud('截图导出能力暂未接入');
  }

  void setBuffering(bool value) {
    isBuffering.value = value;
  }

  void handlePlaybackError(String message) {
    final cleanMessage = message.trim();
    if (cleanMessage.isEmpty) {
      showError(
        currentItem.value.isRemote
            ? kPlayerNetworkErrorMessage
            : kPlayerDecodeErrorMessage,
      );
      return;
    }
    showError('$kPlayerPlaybackErrorPrefix$cleanMessage');
  }

  void clearError() {
    errorMessage.value = null;
    isBuffering.value = false;
    showControls();
  }

  Future<void> retryCurrentItem() async {
    clearError();
    await openCurrentItem(restoreProgress: true, showRestoreMessage: false);
  }

  void beginSurfaceGesture({
    required Offset localPosition,
    required Size viewportSize,
  }) {
    handleSurfaceGestureStart(
      localPosition: localPosition,
      viewportSize: viewportSize,
    );
  }

  void updateSurfaceGesture({required Offset localPosition}) {
    handleSurfaceGestureUpdate(localPosition: localPosition);
  }

  void endSurfaceGesture() {
    handleSurfaceGestureEnd();
  }
}
