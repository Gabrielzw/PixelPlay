part of 'player_controller.dart';

extension PlayerControllerPlaybackLogic on PlayerController {
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
    duration.value = value > Duration.zero ? value : currentItem.value.duration;
    final pendingRestorePosition = _pendingRestorePosition;
    if (pendingRestorePosition != null) {
      final clampedRestorePosition = _clampToDuration(pendingRestorePosition);
      _pendingRestorePosition = clampedRestorePosition;
      applyPosition(clampedRestorePosition);
      _latestObservedPosition = clampedRestorePosition;
      _lastSyncedPosition = clampedRestorePosition;
    }
    applyPosition(position.value);
  }

  void _handlePositionChanged(Duration value) {
    final nextPosition = value.isNegative ? Duration.zero : value;
    final pendingRestorePosition = _pendingRestorePosition;
    if (pendingRestorePosition != null &&
        !_isRestoredPositionReached(
          position: nextPosition,
          restoredPosition: pendingRestorePosition,
        )) {
      return;
    }

    _pendingRestorePosition = null;
    _latestObservedPosition = nextPosition;
    if (_pendingSeekPosition != null || !_shouldSyncPosition(nextPosition)) {
      return;
    }
    applyPosition(nextPosition);
    _lastPositionSyncAt = DateTime.now();
    _lastSyncedPosition = nextPosition;
  }

  Future<void> _syncPlaybackPreferences() async {
    await playbackPort.setPlaybackSpeed(playbackSpeed.value);
    await playbackPort.setVolume(kGestureDefaultLevel);
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
    resetVideoTransform();
    duration.value = item.duration;
    applyPosition(Duration.zero);
    isBuffering.value = true;
    _isOpeningCurrentItem = true;

    try {
      final restoredPosition = restoreProgress
          ? await _resolveRestorablePosition()
          : null;
      await playbackPort.open(
        item,
        play: false,
        startPosition: restoredPosition,
      );
      await _syncPlaybackPreferences();
      if (restoredPosition != null) {
        _applyRestoredProgress(
          restoredPosition: restoredPosition,
          showMessage: showRestoreMessage,
        );
      }
      await playbackPort.play();
    } catch (error) {
      handlePlaybackError(_cleanPlaybackError(error));
    } finally {
      _isOpeningCurrentItem = false;
    }
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

  void _applyRestoredProgress({
    required Duration restoredPosition,
    required bool showMessage,
  }) {
    final clampedRestorePosition = _clampToDuration(restoredPosition);
    _pendingRestorePosition = clampedRestorePosition;
    applyPosition(clampedRestorePosition);
    _latestObservedPosition = clampedRestorePosition;
    _lastPositionSyncAt = DateTime.now();
    _lastSyncedPosition = clampedRestorePosition;
    if (showMessage) {
      showInfoHud('已恢复播放进度');
    }
  }

  Future<void> persistCurrentProgress() async {
    if (!settingsController.settings.value.rememberPlaybackPosition ||
        !hasKnownDuration) {
      return;
    }

    final currentPosition = await _resolvePersistablePosition();
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

  Future<Duration> _resolvePersistablePosition() async {
    final currentPosition = _resolvePersistedPosition();
    if (currentPosition > Duration.zero || !_isOpeningCurrentItem) {
      return currentPosition;
    }

    final restoredPosition = await _resolveRestorablePosition();
    if (restoredPosition == null) {
      return Duration.zero;
    }
    return _clampToDuration(restoredPosition);
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

    final pendingRestorePosition = _pendingRestorePosition;
    if (pendingRestorePosition != null) {
      return _clampToDuration(pendingRestorePosition);
    }

    final latestPosition = _latestObservedPosition;
    if (latestPosition > position.value) {
      return _clampToDuration(latestPosition);
    }
    return _clampToDuration(position.value);
  }

  bool _isRestoredPositionReached({
    required Duration position,
    required Duration restoredPosition,
  }) {
    return position + kPlaybackPositionJumpThreshold >= restoredPosition;
  }

  void _resetPlaybackTracking() {
    _progressSaveTimer?.cancel();
    _gestureSession = null;
    _pendingSeekPosition = null;
    _pendingRestorePosition = null;
    _lastPositionSyncAt = null;
    _lastSyncedPosition = Duration.zero;
    _latestObservedPosition = Duration.zero;
    _isOpeningCurrentItem = false;
  }
}
