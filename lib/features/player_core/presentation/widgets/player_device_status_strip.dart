import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import '../../domain/player_device_port.dart';

const TextStyle _kStatusTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 11,
  fontWeight: FontWeight.w500,
);

class PlayerDeviceStatusStrip extends StatelessWidget {
  final PlayerController controller;

  const PlayerDeviceStatusStrip({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final batteryLevel = controller.batteryLevel.value;
      final isCharging = controller.isCharging.value;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(controller.currentTimeText.value, style: _kStatusTextStyle),
          const SizedBox(width: 8),
          Icon(
            _resolveNetworkIcon(controller.networkStatus.value),
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          if (isCharging)
            const Padding(
              padding: EdgeInsets.only(right: 2),
              child: Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
            ),
          Text('$batteryLevel%', style: _kStatusTextStyle),
          const SizedBox(width: 2),
          Icon(
            _resolveBatteryIcon(batteryLevel, isCharging),
            color: _resolveBatteryColor(batteryLevel, isCharging),
            size: 16,
          ),
        ],
      );
    });
  }

  IconData _resolveBatteryIcon(int level, bool isCharging) {
    if (isCharging) {
      return Icons.battery_charging_full_rounded;
    }
    if (level >= 90) {
      return Icons.battery_full_rounded;
    }
    if (level >= 80) {
      return Icons.battery_6_bar_rounded;
    }
    if (level >= 60) {
      return Icons.battery_5_bar_rounded;
    }
    if (level >= 50) {
      return Icons.battery_4_bar_rounded;
    }
    if (level >= 30) {
      return Icons.battery_3_bar_rounded;
    }
    if (level >= 20) {
      return Icons.battery_2_bar_rounded;
    }
    if (level >= 10) {
      return Icons.battery_1_bar_rounded;
    }
    return Icons.battery_alert_rounded;
  }

  Color _resolveBatteryColor(int level, bool isCharging) {
    if (isCharging) {
      return Colors.greenAccent;
    }
    if (level < 20) {
      return Colors.redAccent;
    }
    return Colors.white;
  }

  IconData _resolveNetworkIcon(PlayerNetworkStatus status) {
    return switch (status) {
      PlayerNetworkStatus.wifi => Icons.wifi_rounded,
      PlayerNetworkStatus.mobile => Icons.signal_cellular_4_bar_rounded,
      PlayerNetworkStatus.ethernet => Icons.settings_ethernet_rounded,
      PlayerNetworkStatus.offline => Icons.signal_cellular_off_rounded,
      PlayerNetworkStatus.unknown => Icons.device_unknown_rounded,
    };
  }
}
