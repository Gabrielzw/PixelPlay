import 'dart:async';

import 'package:flutter/foundation.dart';

enum PlayerNetworkStatus { wifi, mobile, ethernet, offline, unknown }

@immutable
class PlayerBatteryInfo {
  final int level;
  final bool isCharging;

  const PlayerBatteryInfo({required this.level, required this.isCharging});

  PlayerBatteryInfo copyWith({int? level, bool? isCharging}) {
    return PlayerBatteryInfo(
      level: level ?? this.level,
      isCharging: isCharging ?? this.isCharging,
    );
  }
}

@immutable
class PlayerDeviceSnapshot {
  final double brightnessLevel;
  final double volumeLevel;
  final String timeText;
  final PlayerNetworkStatus networkStatus;
  final PlayerBatteryInfo batteryInfo;

  const PlayerDeviceSnapshot({
    required this.brightnessLevel,
    required this.volumeLevel,
    required this.timeText,
    required this.networkStatus,
    required this.batteryInfo,
  });

  PlayerDeviceSnapshot copyWith({
    double? brightnessLevel,
    double? volumeLevel,
    String? timeText,
    PlayerNetworkStatus? networkStatus,
    PlayerBatteryInfo? batteryInfo,
  }) {
    return PlayerDeviceSnapshot(
      brightnessLevel: brightnessLevel ?? this.brightnessLevel,
      volumeLevel: volumeLevel ?? this.volumeLevel,
      timeText: timeText ?? this.timeText,
      networkStatus: networkStatus ?? this.networkStatus,
      batteryInfo: batteryInfo ?? this.batteryInfo,
    );
  }
}

abstract interface class PlayerDevicePort {
  Future<void> attach();

  Future<void> detach();

  Future<PlayerDeviceSnapshot> loadSnapshot();

  Stream<double> watchBrightness();

  Stream<double> watchVolume();

  Stream<String> watchClock();

  Stream<PlayerNetworkStatus> watchNetwork();

  Stream<PlayerBatteryInfo> watchBattery();

  Future<void> setBrightness(double brightness);

  Future<void> setVolume(double volume);
}
