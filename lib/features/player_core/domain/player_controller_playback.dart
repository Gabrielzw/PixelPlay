part of 'player_controller.dart';

extension _PlayerPlaybackLogic on PlayerController {
  Future<void> switchToIndex(int index) async {
    await persistCurrentProgress();
    _progressSaveTimer?.cancel();
    _gestureSession = null;
    errorMessage.value = null;
    isBuffering.value = false;

    final nextItem = queue[index];
    currentIndex.value = index;
    currentItem.value = nextItem;
    duration.value = nextItem.duration;
    applyPosition(Duration.zero);

    await restoreCurrentProgress(showMessage: true);
    showControls();
    armControlsAutoHide();
  }

  Future<void> restoreCurrentProgress({required bool showMessage}) async {
    if (!settingsController.settings.value.rememberPlaybackPosition) {
      return;
    }

    final item = currentItem.value;
    final record = await playbackPositionRepository.load(item.id);
    final restoredPositionMs = record?.positionMs ?? item.lastKnownPositionMs;
    final restoredDurationMs =
        record?.durationMs ?? item.duration.inMilliseconds;

    if (restoredPositionMs == null || restoredDurationMs <= 0) {
      return;
    }

    final restoredRatio = restoredPositionMs / restoredDurationMs;
    if (restoredRatio <= kPlaybackRestoreMinRatio ||
        restoredRatio >= kPlaybackRestoreMaxRatio) {
      return;
    }

    applyPosition(Duration(milliseconds: restoredPositionMs));
    if (showMessage) {
      showInfoHud('已恢复播放进度');
    }
  }

  Future<void> persistCurrentProgress() async {
    if (!settingsController.settings.value.rememberPlaybackPosition ||
        !hasKnownDuration) {
      return;
    }

    final ratio = progress.value;
    final itemId = currentItem.value.id;
    if (ratio <= kPlaybackRestoreMinRatio ||
        ratio >= kPlaybackRestoreMaxRatio) {
      await playbackPositionRepository.clear(itemId);
      return;
    }

    await playbackPositionRepository.save(
      PlaybackPositionRecord(
        mediaId: itemId,
        positionMs: position.value.inMilliseconds,
        durationMs: duration.value.inMilliseconds,
      ),
    );
  }

  void applyPosition(Duration nextPosition) {
    if (!hasKnownDuration) {
      position.value = Duration.zero;
      progress.value = 0;
      return;
    }

    final clampedMs = nextPosition.inMilliseconds.clamp(
      0,
      duration.value.inMilliseconds,
    );
    position.value = Duration(milliseconds: clampedMs);
    progress.value = clampedMs / duration.value.inMilliseconds;
  }

  void showControls() {
    controlsVisible.value = true;
  }

  void hideControls() {
    controlsVisible.value = false;
    cancelControlsAutoHide();
  }

  void armControlsAutoHide() {
    if (!controlsVisible.value || controlsLocked.value || !isPlaying.value) {
      return;
    }

    cancelControlsAutoHide();
    _controlsTimer = Timer(kControlsAutoHideDelay, hideControls);
  }

  void cancelControlsAutoHide() {
    _controlsTimer?.cancel();
  }

  void scheduleProgressSave() {
    _progressSaveTimer?.cancel();
    _progressSaveTimer = Timer(
      kProgressSaveDebounce,
      () => unawaited(persistCurrentProgress()),
    );
  }

  void showError(String message) {
    isPlaying.value = false;
    isBuffering.value = false;
    errorMessage.value = message;
    showControls();
    cancelControlsAutoHide();
  }
}
