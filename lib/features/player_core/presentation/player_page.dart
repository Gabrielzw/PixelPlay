import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/player_controller.dart';
import 'widgets/player_layout.dart';
import 'widgets/player_ui_constants.dart';

class PlayerPage extends GetView<PlayerController> {
  final String title;

  const PlayerPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPlayerBackground,
      body: SafeArea(
        child: Obx(() {
          return PlayerLayout(
            title: title,
            isPlaying: controller.isPlaying.value,
            controlsLocked: controller.controlsLocked.value,
            progress: controller.progress.value,
            onBack: () => Get.back<void>(),
            onTogglePlay: controller.togglePlay,
            onToggleLock: controller.toggleLock,
            onSeek: controller.seekTo,
          );
        }),
      ),
    );
  }
}

