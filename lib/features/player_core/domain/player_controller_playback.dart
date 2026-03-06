part of 'player_controller.dart';

extension _PlayerPlaybackLogic on PlayerController {
  void _bindPlaybackStreams() {
    _playbackSubscriptions.add(
      playbackPort.playingStream.listen((bool value) {
        isPlaying.value = value;
        if (value) {
          armControlsAutoHide();
        }
      }),
    );
    _playbackSubscriptions.add(
      playbackPort.bufferingStream.listen((bool value) => setBuffering(value)),
    );
    _playbackSubscriptions.add(
      playbackPort.durationStream.listen((Duration value) {
        duration.value = value > Duration.zero ? value : currentItem.value.duration;
        applyPosition(position.value);
      }),
    );
    _playbackSubscriptions.add(
      playbackPort.positionStream.listen((Duration value) {
        if (_pendingSeekPosition != null || !_shouldSyncPosition(value)) {
          return;
        }
        applyPosition(value);
        _lastPositionSyncAt = DateTime.now();
        _lastSyncedPosition = value;
      }),
    );
    _playbackSubscriptions.add(
      playbackPort.completedStream.listen((bool value) {
        if (value) {
          unawaited(handlePlaybackCompleted());
        }
      }),
    );
    _playbackSubscriptions.add(
      playbackPort.errorStream.listen(handlePlaybackError),
    );
  }

  Future<void> _syncPlaybackPreferences() async {
    await playbackPort.setPlaybackSpeed(playbackSpeed.value);
    await playbackPort.setVolume(volumeLevel.value);
  }

  Future<void> switchToIndex(int index) async {
    await persistCurrentProgress();
    _progressSaveTimer?.cancel();
    _gestureSession = null;
    _pendingSeekPosition = null;
    _lastPositionSyncAt = null;
    _lastSyncedPosition = Duration.zero;

    final nextItem = queue[index];
    currentIndex.value = index;
    currentItem.value = nextItem;
    duration.value = nextItem.duration;
    clearError();
    applyPosition(Duration.zero);
    showControls();
    await openCurrentItem(restoreProgress: true, showRestoreMessage: true);
    armControlsAutoHide();
  }

  Future<void> openCurrentItem({
    required bool restoreProgress,
    required bool showRestoreMessage,
  }) async {
    final item = currentItem.value;
    if (!item.hasPlayableSource) {
      showError(kPlayerMissingSourceMessage);
      return;
    }

    clearError();
    _pendingSeekPosition = null;
    _lastPositionSyncAt = null;
    _lastSyncedPosition = Duration.zero;
    duration.value = item.duration;
    applyPosition(Duration.zero);
    isBuffering.value = true;

    try {
      await playbackPort.open(item, play: true);
      await _syncPlaybackPreferences();
      if (restoreProgress) {
        await restoreCurrentProgress(showMessage: showRestoreMessage);
      }
    } catch (error) {
      handlePlaybackError(_cleanPlaybackError(error));
    }
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

    final restoredPosition = Duration(milliseconds: restoredPositionMs);
    previewSeekPosition(restoredPosition);
    await playbackPort.seek(restoredPosition);
    _pendingSeekPosition = null;
    if (showMessage) {
      showInfoHud('已恢复播放进度');
    }
  }

  Future<void> persistCurrentProgress() async {
    if (!settingsController.settings.value.rememberPlaybackPosition ||
        !hasKnownDuration) {
      return;
    }

    final currentPosition = _pendingSeekPosition ?? position.value;
    final progressRatio = currentPosition.inMilliseconds /
        duration.value.inMilliseconds;
    final itemId = currentItem.value.id;
    if (progressRatio <= kPlaybackRestoreMinRatio ||
        progressRatio >= kPlaybackRestoreMaxRatio) {
      await playbackPositionRepository.clear(itemId);
      return;
    }

    await playbackPositionRepository.save(
      PlaybackPositionRecord(
        mediaId: itemId,
        positionMs: currentPosition.inMilliseconds,
        durationMs: duration.value.inMilliseconds,
      ),
    );
  }

  void applyPosition(Duration nextPosition) {
    final clampedPosition = _clampToDuration(nextPosition);
    position.value = clampedPosition;
    if (!hasKnownDuration) {
      progress.value = 0;
      return;
    }

    progress.value =
        clampedPosition.inMilliseconds / duration.value.inMilliseconds;
  }

  void previewSeekPosition(Duration nextPosition) {
    _pendingSeekPosition = _clampToDuration(nextPosition);
    applyPosition(_pendingSeekPosition!);
  }

  Duration _clampToDuration(Duration value) {
    if (!hasKnownDuration) {
      return value.isNegative ? Duration.zero : value;
    }

    final clampedMs = value.inMilliseconds.clamp(
      0,
      duration.value.inMilliseconds,
    );
    return Duration(milliseconds: clampedMs);
  }

  bool _shouldSyncPosition(Duration nextPosition) {
    final lastSyncAt = _lastPositionSyncAt;
    if (lastSyncAt == null) {
      return true;
    }

    final syncAge = DateTime.now().difference(lastSyncAt);
    final positionDeltaMs =
        (nextPosition.inMilliseconds - _lastSyncedPosition.inMilliseconds).abs();
    if (syncAge >= kPlaybackPositionSyncInterval) {
      return true;
    }
    return positionDeltaMs >= kPlaybackPositionJumpThreshold.inMilliseconds;
  }

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
