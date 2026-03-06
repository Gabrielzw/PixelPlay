import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../settings/domain/app_settings.dart';
import '../../settings/domain/settings_controller.dart';
import 'playback_position_repository.dart';
import 'player_queue_item.dart';

part 'player_controller_state.dart';
part 'player_controller_gestures.dart';
part 'player_controller_playback.dart';

class PlayerController extends GetxController {
  final SettingsController settingsController;
  final PlaybackPositionRepository playbackPositionRepository;
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

  Timer? _controlsTimer;
  Timer? _hudTimer;
  Timer? _progressSaveTimer;
  _PlayerGestureSession? _gestureSession;

  PlayerController({
    required this.settingsController,
    required this.playbackPositionRepository,
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

  bool get isNetworkError => errorMessage.value == kPlayerNetworkErrorMessage;

  @override
  Future<void> onReady() async {
    super.onReady();
    await restoreCurrentProgress(showMessage: true);
    armControlsAutoHide();
  }

  @override
  void onClose() {
    unawaited(persistCurrentProgress());
    _controlsTimer?.cancel();
    _hudTimer?.cancel();
    _progressSaveTimer?.cancel();
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

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      armControlsAutoHide();
      return;
    }
    showControls();
    cancelControlsAutoHide();
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
      isPlaying.value = false;
      showControls();
      return;
    }
    await playNext();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeed.value = speed;
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

  void seekToRatio(double value) {
    if (!hasKnownDuration) {
      return;
    }

    final safeValue = value.clamp(0.0, 1.0);
    final nextPosition = Duration(
      milliseconds: (duration.value.inMilliseconds * safeValue).round(),
    );
    applyPosition(nextPosition);
    scheduleProgressSave();
    armControlsAutoHide();
  }

  Future<void> resetCurrentProgress() async {
    await playbackPositionRepository.clear(currentItem.value.id);
    applyPosition(Duration.zero);
    showInfoHud('已清除当前播放进度');
  }

  void showScreenshotUnavailable() {
    showInfoHud('截图保存待接入媒体帧导出');
  }

  void setBuffering(bool value) {
    isBuffering.value = value;
  }

  void showDecodeError() {
    showError(kPlayerDecodeErrorMessage);
  }

  void showNetworkError() {
    showError(kPlayerNetworkErrorMessage);
  }

  void clearError() {
    errorMessage.value = null;
    isBuffering.value = false;
    showControls();
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
