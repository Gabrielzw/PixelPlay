import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../settings/domain/settings_controller.dart';
import '../data/media_kit_playback_adapter.dart';
import '../../settings/presentation/player_settings_page.dart';
import '../domain/playback_position_repository.dart';
import '../domain/player_controller.dart';
import '../domain/player_playback_port.dart';
import '../domain/player_queue_item.dart';
import 'widgets/player_layout.dart';
import 'widgets/player_ui_constants.dart';

class PlayerPage extends StatefulWidget {
  final List<PlayerQueueItem> playlist;
  final int initialIndex;
  final PlayerPlaybackPort? playbackPort;

  const PlayerPage({
    super.key,
    required this.playlist,
    this.initialIndex = 0,
    this.playbackPort,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final String _controllerTag;
  late final PlayerPlaybackPort _playbackPort;
  late final PlayerController _controller;
  bool _isPersistingBeforeExit = false;

  @override
  void initState() {
    super.initState();
    _controllerTag = 'player_${identityHashCode(this)}';
    _playbackPort = widget.playbackPort ?? MediaKitPlaybackAdapter();
    _controller = Get.put<PlayerController>(
      PlayerController(
        settingsController: Get.find<SettingsController>(),
        playbackPositionRepository: Get.find<PlaybackPositionRepository>(),
        playbackPort: _playbackPort,
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
    _playbackPort.disposePlayback();
    _restoreSystemUi();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: WillPopScope(
        onWillPop: _handleWillPop,
        child: Scaffold(
          backgroundColor: kPlayerBackground,
          body: PlayerLayout(
            controller: _controller,
            playbackPort: _playbackPort,
            onBack: _handleBack,
            onOpenSettings: _openSettings,
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    Navigator.of(context).maybePop();
  }

  Future<bool> _handleWillPop() async {
    if (_isPersistingBeforeExit) {
      return false;
    }

    _isPersistingBeforeExit = true;
    try {
      await _controller.persistProgressBeforeExit();
      return true;
    } finally {
      _isPersistingBeforeExit = false;
    }
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
