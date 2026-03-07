part of 'player_controller.dart';

extension PlayerControllerVisibility on PlayerController {
  String _cleanPlaybackError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('Bad state: ', '')
        .trim();
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
