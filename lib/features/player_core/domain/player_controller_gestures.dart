part of 'player_controller.dart';

extension _PlayerGestureLogic on PlayerController {
  void handleSurfaceGestureStart({
    required Offset localPosition,
    required Size viewportSize,
    required int pointerCount,
  }) {
    if (controlsLocked.value) {
      return;
    }

    _hudTimer?.cancel();
    _gestureSession = _createGestureSession(
      startOffset: localPosition,
      viewportSize: viewportSize,
      pointerCount: pointerCount,
    );
    if (pointerCount >= 2) {
      hudState.value = null;
    }
  }

  void handleSurfaceGestureUpdate({
    required Offset localPosition,
    required int pointerCount,
    required double scale,
    required double rotation,
  }) {
    final session = _gestureSession;
    if (session == null) {
      return;
    }

    if (pointerCount != session.pointerCount) {
      _gestureSession = _createGestureSession(
        startOffset: localPosition,
        viewportSize: session.viewportSize,
        pointerCount: pointerCount,
      );
      if (pointerCount >= 2) {
        hudState.value = null;
      }
      return;
    }

    if (pointerCount >= 2) {
      applyTransformGesture(
        session,
        localPosition: localPosition,
        scale: scale,
        rotation: rotation,
      );
      return;
    }

    final delta = localPosition - session.startOffset;
    session.mode = resolveGestureMode(session, delta);
    switch (session.mode) {
      case _PlayerGestureMode.pending:
      case _PlayerGestureMode.none:
        return;
      case _PlayerGestureMode.transform:
        return;
      case _PlayerGestureMode.seek:
        applySeekGesture(session, delta.dx);
        return;
      case _PlayerGestureMode.brightness:
        applyBrightnessGesture(session, delta.dy);
        return;
      case _PlayerGestureMode.volume:
        applyVolumeGesture(session, delta.dy);
        return;
    }
  }

  void handleSurfaceGestureEnd() {
    if (_gestureSession?.mode == _PlayerGestureMode.seek) {
      unawaited(commitSeekPreview());
    }
    _gestureSession = null;
    scheduleHudHide();
    armControlsAutoHide();
  }

  _PlayerGestureMode resolveGestureMode(
    _PlayerGestureSession session,
    Offset delta,
  ) {
    if (session.mode != _PlayerGestureMode.pending) {
      return session.mode;
    }

    final deltaX = delta.dx.abs();
    final deltaY = delta.dy.abs();
    if (deltaX < kGestureDecisionSlop && deltaY < kGestureDecisionSlop) {
      return _PlayerGestureMode.pending;
    }
    if (deltaX >= deltaY) {
      return hasKnownDuration
          ? _PlayerGestureMode.seek
          : _PlayerGestureMode.none;
    }

    final zone = session.startOffset.dx / session.viewportSize.width;
    if (zone <= 1 / 3) {
      return _PlayerGestureMode.brightness;
    }
    if (zone >= 2 / 3) {
      return _PlayerGestureMode.volume;
    }
    return _PlayerGestureMode.none;
  }

  void applySeekGesture(_PlayerGestureSession session, double deltaX) {
    final settings = settingsController.settings.value;
    final seekRangeSeconds =
        settings.gestureSeekUsesVideoDuration && hasKnownDuration
        ? duration.value.inSeconds.toDouble()
        : settings.gestureSeekSecondsPerSwipe.toDouble();
    final secondsOffset =
        (deltaX / session.viewportSize.width) * seekRangeSeconds;
    final nextPosition =
        session.basePosition +
        Duration(milliseconds: (secondsOffset * 1000).round());

    previewSeekPosition(nextPosition);
    showHud(
      PlayerHudState(
        kind: PlayerHudKind.seek,
        primaryText:
            '${formatSeekOffset(secondsOffset)} / ${formatDuration(position.value)}',
      ),
    );
  }

  void applyBrightnessGesture(_PlayerGestureSession session, double deltaY) {
    final nextValue =
        session.baseBrightness - deltaY / session.viewportSize.height;
    final brightness = nextValue.clamp(0.0, 1.0).toDouble();
    brightnessLevel.value = brightness;
    unawaited(updateBrightnessLevel(brightness));
    showHud(
      PlayerHudState(
        kind: PlayerHudKind.brightness,
        primaryText: '亮度 ${(brightnessLevel.value * 100).round()}%',
        alignment: const Alignment(-0.72, 0),
      ),
    );
  }

  void applyVolumeGesture(_PlayerGestureSession session, double deltaY) {
    final nextValue = session.baseVolume - deltaY / session.viewportSize.height;
    final volume = nextValue.clamp(0.0, 1.0).toDouble();
    volumeLevel.value = volume;
    unawaited(updateVolumeLevel(volume));
    showHud(
      PlayerHudState(
        kind: PlayerHudKind.volume,
        primaryText: '音量 ${(volumeLevel.value * 100).round()}%',
        alignment: const Alignment(0.72, 0),
      ),
    );
  }

  void applyTransformGesture(
    _PlayerGestureSession session, {
    required Offset localPosition,
    required double scale,
    required double rotation,
  }) {
    session.mode = _PlayerGestureMode.transform;
    final deltaMatrix = Matrix4.identity()
      ..translateByDouble(localPosition.dx, localPosition.dy, 0, 1)
      ..rotateZ(rotation)
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(
        -session.transformFocalPoint.dx,
        -session.transformFocalPoint.dy,
        0,
        1,
      );
    applyVideoTransform(deltaMatrix * session.baseTransform);
  }

  _PlayerGestureSession _createGestureSession({
    required Offset startOffset,
    required Size viewportSize,
    required int pointerCount,
  }) {
    final session = _PlayerGestureSession(
      startOffset: startOffset,
      viewportSize: viewportSize,
      basePosition: position.value,
      baseBrightness: brightnessLevel.value,
      baseVolume: volumeLevel.value,
      pointerCount: pointerCount,
      baseTransform: Matrix4.copy(videoTransform.value),
      transformFocalPoint: startOffset,
    );
    if (pointerCount >= 2) {
      session.mode = _PlayerGestureMode.transform;
    }
    return session;
  }

  void showHud(PlayerHudState nextHud) {
    hudState.value = nextHud;
  }

  void showInfoHud(String message) {
    showHud(PlayerHudState(kind: PlayerHudKind.info, primaryText: message));
    scheduleHudHide();
  }

  void scheduleHudHide() {
    _hudTimer?.cancel();
    _hudTimer = Timer(kGestureHudHideDelay, () => hudState.value = null);
  }

  String formatSeekOffset(double secondsOffset) {
    final wholeSeconds = secondsOffset.round();
    final prefix = wholeSeconds >= 0 ? '+' : '-';
    return '$prefix${wholeSeconds.abs()}s';
  }

  String formatDuration(Duration value) {
    final totalSeconds = value.inSeconds;
    final hours = totalSeconds ~/ Duration.secondsPerHour;
    final minutes =
        (totalSeconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;
    final seconds = totalSeconds % Duration.secondsPerMinute;
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  String twoDigits(int value) => value.toString().padLeft(2, '0');
}
