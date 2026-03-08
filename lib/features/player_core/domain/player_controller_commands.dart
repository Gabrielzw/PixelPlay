part of 'player_controller.dart';

extension PlayerControllerCommands on PlayerController {
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
      cancelControlsAutoHide();
      return;
    }

    clearError();
    await playbackPort.play();
    armControlsAutoHide();
  }

  Future<void> persistProgressBeforeExit() async {
    await persistCurrentPlaybackState();
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
    final settings = settingsController.settings.value;
    switch (settings.defaultPlaybackMode) {
      case PlayerPlaybackMode.noLoop:
        applyPosition(duration.value);
        showControls();
        cancelControlsAutoHide();
        return;
      case PlayerPlaybackMode.loopSingle:
        applyPosition(Duration.zero);
        await playbackPort.seek(Duration.zero);
        await playbackPort.play();
        armControlsAutoHide();
        return;
      case PlayerPlaybackMode.loopList:
        final nextIndex = hasNext ? currentIndex.value + 1 : 0;
        await switchToIndex(nextIndex);
        return;
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeed.value = speed;
    await playbackPort.setPlaybackSpeed(speed);
    await settingsController.setDefaultPlaybackSpeed(speed);
    showSpeedHud('播放速度 ${speed}x');
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
    _latestObservedPosition = pendingPosition;
    _lastPositionSyncAt = DateTime.now();
    _lastSyncedPosition = pendingPosition;
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
  }

  Future<void> retryCurrentItem() async {
    clearError();
    await openCurrentItem(restoreProgress: true, autoPlay: true);
  }

  void beginSurfaceGesture({
    required Offset localPosition,
    required Size viewportSize,
    required int pointerCount,
  }) {
    handleSurfaceGestureStart(
      localPosition: localPosition,
      viewportSize: viewportSize,
      pointerCount: pointerCount,
    );
  }

  void updateSurfaceGesture({
    required Offset localPosition,
    required int pointerCount,
    required double scale,
    required double rotation,
  }) {
    handleSurfaceGestureUpdate(
      localPosition: localPosition,
      pointerCount: pointerCount,
      scale: scale,
      rotation: rotation,
    );
  }

  void endSurfaceGesture() {
    handleSurfaceGestureEnd();
  }
}
