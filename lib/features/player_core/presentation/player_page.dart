import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../settings/domain/settings_controller.dart';
import '../../settings/presentation/player_settings_page.dart';
import '../domain/playback_position_repository.dart';
import '../domain/player_controller.dart';
import '../domain/player_queue_item.dart';
import 'widgets/player_layout.dart';
import 'widgets/player_ui_constants.dart';

class PlayerPage extends StatefulWidget {
  final List<PlayerQueueItem> playlist;
  final int initialIndex;

  const PlayerPage({super.key, required this.playlist, this.initialIndex = 0});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    _controllerTag = 'player_${identityHashCode(this)}';
    Get.put<PlayerController>(
      PlayerController(
        settingsController: Get.find<SettingsController>(),
        playbackPositionRepository: Get.find<PlaybackPositionRepository>(),
        queue: widget.playlist,
        initialIndex: widget.initialIndex,
      ),
      tag: _controllerTag,
    );
    _enterImmersiveMode();
  }

  @override
  void dispose() {
    Get.delete<PlayerController>(tag: _controllerTag, force: true);
    _restoreSystemUi();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kPlayerBackground,
        body: PlayerLayout(
          controller: Get.find<PlayerController>(tag: _controllerTag),
          onBack: _handleBack,
          onOpenSettings: _openSettings,
        ),
      ),
    );
  }

  void _handleBack() {
    Navigator.of(context).maybePop();
  }

  Future<void> _openSettings() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const PlayerSettingsPage()));
  }

  void _enterImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  void _restoreSystemUi() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
