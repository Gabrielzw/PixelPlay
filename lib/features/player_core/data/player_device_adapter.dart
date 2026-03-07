import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../domain/player_device_port.dart';

const Duration kPlayerClockRefreshInterval = Duration(minutes: 1);
const Duration kPlayerBatteryRefreshInterval = Duration(minutes: 1);
const AudioStream kPlayerVolumeAudioStream = AudioStream.music;

class PlayerDeviceAdapter implements PlayerDevicePort {
  final Battery _battery;
  final Connectivity _connectivity;
  final ScreenBrightness _screenBrightness;
  final StreamController<double> _volumeController;

  StreamSubscription<double>? _volumeSubscription;

  PlayerDeviceAdapter({
    Battery? battery,
    Connectivity? connectivity,
    ScreenBrightness? screenBrightness,
    StreamController<double>? volumeController,
  }) : _battery = battery ?? Battery(),
       _connectivity = connectivity ?? Connectivity(),
       _screenBrightness = screenBrightness ?? ScreenBrightness(),
       _volumeController =
           volumeController ?? StreamController<double>.broadcast();

  @override
  Future<void> attach() async {
    await FlutterVolumeController.updateShowSystemUI(false);
    await FlutterVolumeController.setAndroidAudioStream(
      stream: kPlayerVolumeAudioStream,
    );
    await _volumeSubscription?.cancel();
    _volumeSubscription = FlutterVolumeController.addListener(
      (double volume) => _volumeController.add(_clampLevel(volume)),
      stream: kPlayerVolumeAudioStream,
    );
  }

  @override
  Future<void> detach() async {
    final subscription = _volumeSubscription;
    _volumeSubscription = null;
    await subscription?.cancel();
    FlutterVolumeController.removeListener();
    await FlutterVolumeController.updateShowSystemUI(true);
    await _screenBrightness.resetApplicationScreenBrightness();
  }

  @override
  Future<PlayerDeviceSnapshot> loadSnapshot() async {
    final brightnessLevel = _clampLevel(await _screenBrightness.application);
    final volumeLevel = _resolveVolume(
      await FlutterVolumeController.getVolume(stream: kPlayerVolumeAudioStream),
    );
    final networkStatus = _mapNetworkStatus(
      await _connectivity.checkConnectivity(),
    );
    final batteryInfo = await _readBatteryInfo();
    return PlayerDeviceSnapshot(
      brightnessLevel: brightnessLevel,
      volumeLevel: volumeLevel,
      timeText: _formatTime(DateTime.now()),
      networkStatus: networkStatus,
      batteryInfo: batteryInfo,
    );
  }

  @override
  Future<void> setBrightness(double brightness) {
    return _screenBrightness.setApplicationScreenBrightness(
      _clampLevel(brightness),
    );
  }

  @override
  Future<void> setVolume(double volume) {
    return FlutterVolumeController.setVolume(
      _clampLevel(volume),
      stream: kPlayerVolumeAudioStream,
    );
  }

  @override
  Stream<double> watchBrightness() {
    return _screenBrightness.onApplicationScreenBrightnessChanged.map(
      _clampLevel,
    );
  }

  @override
  Stream<PlayerBatteryInfo> watchBattery() {
    final controller = StreamController<PlayerBatteryInfo>();
    StreamSubscription<BatteryState>? batterySubscription;
    Timer? timer;

    Future<void> emitBatteryInfo() async {
      controller.add(await _readBatteryInfo());
    }

    controller.onListen = () {
      unawaited(emitBatteryInfo());
      timer = Timer.periodic(kPlayerBatteryRefreshInterval, (_) {
        unawaited(emitBatteryInfo());
      });
      batterySubscription = _battery.onBatteryStateChanged.listen((_) {
        unawaited(emitBatteryInfo());
      });
    };
    controller.onCancel = () async {
      timer?.cancel();
      await batterySubscription?.cancel();
    };
    return controller.stream;
  }

  @override
  Stream<String> watchClock() async* {
    yield _formatTime(DateTime.now());
    yield* Stream<String>.periodic(
      kPlayerClockRefreshInterval,
      (_) => _formatTime(DateTime.now()),
    );
  }

  @override
  Stream<PlayerNetworkStatus> watchNetwork() {
    return _connectivity.onConnectivityChanged.map(_mapNetworkStatus);
  }

  @override
  Stream<double> watchVolume() => _volumeController.stream;

  Future<PlayerBatteryInfo> _readBatteryInfo() async {
    final level = await _battery.batteryLevel;
    final state = await _battery.batteryState;
    return PlayerBatteryInfo(
      level: level,
      isCharging: state == BatteryState.charging,
    );
  }

  PlayerNetworkStatus _mapNetworkStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return PlayerNetworkStatus.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return PlayerNetworkStatus.mobile;
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return PlayerNetworkStatus.ethernet;
    }
    if (results.contains(ConnectivityResult.none)) {
      return PlayerNetworkStatus.offline;
    }
    return PlayerNetworkStatus.unknown;
  }

  String _formatTime(DateTime now) {
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  double _clampLevel(double value) => value.clamp(0.0, 1.0).toDouble();

  double _resolveVolume(double? value) {
    if (value == null) {
      throw StateError('Failed to read the current system volume.');
    }
    return _clampLevel(value);
  }
}
