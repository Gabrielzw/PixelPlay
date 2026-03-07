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
      playbackPort.durationStream.listen(_handleDurationChanged),
    );
    _playbackSubscriptions.add(
      playbackPort.positionStream.listen(_handlePositionChanged),
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

  void _handleDurationChanged(Duration value) {
    if (value > Duration.zero) {
      _hasObservedPlaybackDuration = true;
    }
    duration.value = value > Duration.zero ? value : currentItem.value.duration;
    applyPosition(position.value);
    if (_pendingRestorePosition != null) {
      unawaited(_applyPendingRestoreIfReady());
    }
  }

  void _handlePositionChanged(Duration value) {
    _latestObservedPosition = value.isNegative ? Duration.zero : value;
    if (_pendingRestorePosition != null ||
        _pendingSeekPosition != null ||
        !_shouldSyncPosition(value)) {
      return;
    }
    applyPosition(value);
    _lastPositionSyncAt = DateTime.now();
    _lastSyncedPosition = value;
  }

  Future<void> _syncPlaybackPreferences() async {
    await playbackPort.setPlaybackSpeed(playbackSpeed.value);
    await playbackPort.setVolume(volumeLevel.value);
  }

  Future<void> switchToIndex(int index) async {
    await persistCurrentProgress();
    _resetPlaybackTracking();

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
    _resetPlaybackTracking();
    duration.value = item.duration;
    applyPosition(Duration.zero);
    isBuffering.value = true;

    try {
      await playbackPort.open(item, play: false);
      await _syncPlaybackPreferences();
      final bool restoreScheduled = restoreProgress
          ? await restoreCurrentProgress(showMessage: showRestoreMessage)
          : false;
      if (!restoreScheduled) {
        await playbackPort.play();
      }
    } catch (error) {
      handlePlaybackError(_cleanPlaybackError(error));
    }
  }

  Future<bool> restoreCurrentProgress({required bool showMessage}) async {
    if (!settingsController.settings.value.rememberPlaybackPosition) {
      return false;
    }

    final restoredPosition = await _resolveRestorablePosition();
    if (restoredPosition == null) {
      return false;
    }

    _pendingRestorePosition = restoredPosition;
    _showPendingRestoreMessage = showMessage;
    await _applyPendingRestoreIfReady();
    return true;
  }

  Future<Duration?> _resolveRestorablePosition() async {
    final item = currentItem.value;
    final record = await playbackPositionRepository.load(item.id);
    final restoredPositionMs = record?.positionMs ?? item.lastKnownPositionMs;

    if (restoredPositionMs == null || restoredPositionMs <= 0) {
      return null;
    }

    return Duration(milliseconds: restoredPositionMs);
  }

  Future<void> persistCurrentProgress() async {
    if (!settingsController.settings.value.rememberPlaybackPosition ||
        !hasKnownDuration) {
      return;
    }

    final currentPosition = _resolvePersistedPosition();
    final itemId = currentItem.value.id;
    if (currentPosition <= Duration.zero) {
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

  Future<void> _applyPendingRestoreIfReady() async {
    final restoredPosition = _pendingRestorePosition;
    if (restoredPosition == null ||
        !_hasObservedPlaybackDuration ||
        _isApplyingPendingRestore) {
      return;
    }

    _isApplyingPendingRestore = true;
    _pendingSeekPosition = _clampToDuration(restoredPosition);
    try {
      await playbackPort.seek(_pendingSeekPosition!);
      applyPosition(_pendingSeekPosition!);
      _latestObservedPosition = _pendingSeekPosition!;
      _lastPositionSyncAt = DateTime.now();
      _lastSyncedPosition = _pendingSeekPosition!;
      _pendingSeekPosition = null;
      _pendingRestorePosition = null;
      final showMessage = _showPendingRestoreMessage;
      _showPendingRestoreMessage = false;
      if (showMessage) {
        showInfoHud('已恢复播放进度');
      }
      await playbackPort.play();
    } catch (error) {
      _pendingSeekPosition = null;
      _pendingRestorePosition = null;
      _showPendingRestoreMessage = false;
      handlePlaybackError(_cleanPlaybackError(error));
    } finally {
      _isApplyingPendingRestore = false;
    }
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
        (nextPosition.inMilliseconds - _lastSyncedPosition.inMilliseconds)
            .abs();
    if (syncAge >= kPlaybackPositionSyncInterval) {
      return true;
    }
    return positionDeltaMs >= kPlaybackPositionJumpThreshold.inMilliseconds;
  }

  Duration _resolvePersistedPosition() {
    final pendingPosition = _pendingSeekPosition;
    if (pendingPosition != null) {
      return _clampToDuration(pendingPosition);
    }

    final latestPosition = _latestObservedPosition;
    if (latestPosition > position.value) {
      return _clampToDuration(latestPosition);
    }
    return _clampToDuration(position.value);
  }

  void _resetPlaybackTracking() {
    _progressSaveTimer?.cancel();
    _gestureSession = null;
    _pendingSeekPosition = null;
    _pendingRestorePosition = null;
    _lastPositionSyncAt = null;
    _lastSyncedPosition = Duration.zero;
    _latestObservedPosition = Duration.zero;
    _showPendingRestoreMessage = false;
    _hasObservedPlaybackDuration = false;
    _isApplyingPendingRestore = false;
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
