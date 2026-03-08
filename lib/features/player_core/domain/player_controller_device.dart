part of 'player_controller.dart';

extension PlayerControllerDeviceLogic on PlayerController {
  bool get hasActiveVideoTransform => !videoTransform.value.isIdentity();

  Future<void> resetPlaybackOrientation() async {
    await _applyPlaybackOrientation(PlayerVideoOrientation.unknown);
  }

  Future<void> syncPlaybackOrientation(PlayerVideoMetadata metadata) async {
    await _applyPlaybackOrientation(metadata.orientation);
  }

  Future<void> bindDeviceFeatures() async {
    await devicePort.attach();
    await refreshDeviceSnapshot();
    _playbackSubscriptions.add(
      devicePort.watchBrightness().listen((double value) {
        brightnessLevel.value = _clampDeviceLevel(value);
      }),
    );
    _playbackSubscriptions.add(
      devicePort.watchVolume().listen((double value) {
        volumeLevel.value = _clampDeviceLevel(value);
      }),
    );
    _playbackSubscriptions.add(
      devicePort.watchClock().listen((String value) {
        currentTimeText.value = value;
      }),
    );
    _playbackSubscriptions.add(
      devicePort.watchNetwork().listen((PlayerNetworkStatus value) {
        networkStatus.value = value;
      }),
    );
    _playbackSubscriptions.add(
      devicePort.watchBattery().listen((PlayerBatteryInfo value) {
        batteryLevel.value = value.level;
        isCharging.value = value.isCharging;
      }),
    );
  }

  Future<void> refreshDeviceSnapshot() async {
    final snapshot = await devicePort.loadSnapshot();
    brightnessLevel.value = _clampDeviceLevel(snapshot.brightnessLevel);
    volumeLevel.value = _clampDeviceLevel(snapshot.volumeLevel);
    currentTimeText.value = snapshot.timeText;
    networkStatus.value = snapshot.networkStatus;
    batteryLevel.value = snapshot.batteryInfo.level;
    isCharging.value = snapshot.batteryInfo.isCharging;
  }

  Future<void> updateBrightnessLevel(double value) async {
    final clampedValue = _clampDeviceLevel(value);
    brightnessLevel.value = clampedValue;
    await devicePort.setBrightness(clampedValue);
  }

  Future<void> updateVolumeLevel(double value) async {
    final clampedValue = _clampDeviceLevel(value);
    volumeLevel.value = clampedValue;
    await devicePort.setVolume(clampedValue);
  }

  void applyVideoTransform(Matrix4 nextTransform) {
    videoTransform.value = Matrix4.copy(nextTransform);
  }

  void resetVideoTransform() {
    videoTransform.value = Matrix4.identity();
  }

  Future<void> _applyPlaybackOrientation(
    PlayerVideoOrientation orientation,
  ) async {
    if (_appliedVideoOrientation == orientation) {
      return;
    }
    _appliedVideoOrientation = orientation;
    await devicePort.setPlaybackOrientation(orientation);
  }

  double _clampDeviceLevel(double value) {
    return value.clamp(0.0, 1.0).toDouble();
  }
}
