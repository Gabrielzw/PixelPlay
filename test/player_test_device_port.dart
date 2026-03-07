import 'dart:async';

import 'package:pixelplay/features/player_core/domain/player_device_port.dart';
import 'package:pixelplay/features/player_core/domain/player_video_metadata.dart';

class TestPlayerDevicePort implements PlayerDevicePort {
  PlayerDeviceSnapshot snapshot;
  PlayerVideoOrientation playbackOrientation = PlayerVideoOrientation.unknown;
  final StreamController<double> _brightnessController;
  final StreamController<double> _volumeController;
  final StreamController<String> _clockController;
  final StreamController<PlayerNetworkStatus> _networkController;
  final StreamController<PlayerBatteryInfo> _batteryController;

  TestPlayerDevicePort({PlayerDeviceSnapshot? snapshot})
    : snapshot =
          snapshot ??
          const PlayerDeviceSnapshot(
            brightnessLevel: 0.5,
            volumeLevel: 0.5,
            timeText: '12:00',
            networkStatus: PlayerNetworkStatus.wifi,
            batteryInfo: PlayerBatteryInfo(level: 80, isCharging: false),
          ),
      _brightnessController = StreamController<double>.broadcast(),
      _volumeController = StreamController<double>.broadcast(),
      _clockController = StreamController<String>.broadcast(),
      _networkController = StreamController<PlayerNetworkStatus>.broadcast(),
      _batteryController = StreamController<PlayerBatteryInfo>.broadcast();

  @override
  Future<void> attach() async {}

  @override
  Future<void> detach() async {
    playbackOrientation = PlayerVideoOrientation.unknown;
    await _brightnessController.close();
    await _volumeController.close();
    await _clockController.close();
    await _networkController.close();
    await _batteryController.close();
  }

  void emitBattery(PlayerBatteryInfo value) {
    snapshot = snapshot.copyWith(batteryInfo: value);
    _batteryController.add(value);
  }

  void emitBrightness(double value) {
    snapshot = snapshot.copyWith(brightnessLevel: value);
    _brightnessController.add(value);
  }

  void emitNetwork(PlayerNetworkStatus value) {
    snapshot = snapshot.copyWith(networkStatus: value);
    _networkController.add(value);
  }

  void emitTime(String value) {
    snapshot = snapshot.copyWith(timeText: value);
    _clockController.add(value);
  }

  void emitVolume(double value) {
    snapshot = snapshot.copyWith(volumeLevel: value);
    _volumeController.add(value);
  }

  @override
  Future<PlayerDeviceSnapshot> loadSnapshot() async => snapshot;

  @override
  Future<void> setBrightness(double brightness) async {
    emitBrightness(brightness);
  }

  @override
  Future<void> setVolume(double volume) async {
    emitVolume(volume);
  }

  @override
  Future<void> setPlaybackOrientation(
    PlayerVideoOrientation orientation,
  ) async {
    playbackOrientation = orientation;
  }

  @override
  Stream<PlayerBatteryInfo> watchBattery() => _batteryController.stream;

  @override
  Stream<double> watchBrightness() => _brightnessController.stream;

  @override
  Stream<String> watchClock() => _clockController.stream;

  @override
  Stream<PlayerNetworkStatus> watchNetwork() => _networkController.stream;

  @override
  Stream<double> watchVolume() => _volumeController.stream;
}
