import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/router/page_navigation.dart';
import '../../../app/router/page_transitions.dart';
import '../../favorites/presentation/controllers/favorites_controller.dart';
import '../../favorites/presentation/favorite_folder_form_page.dart';
import '../../favorites/presentation/favorite_models.dart';
import '../../settings/domain/page_transition_type.dart';
import '../../settings/domain/settings_controller.dart';
import '../data/media_kit_playback_adapter.dart';
import '../data/method_channel_player_screenshot_store.dart';
import '../data/player_device_adapter.dart';
import '../../settings/presentation/player_settings_page.dart';
import '../domain/playback_position_repository.dart';
import '../domain/player_controller.dart';
import '../domain/player_device_port.dart';
import '../domain/player_playback_port.dart';
import '../domain/player_queue_item.dart';
import '../domain/player_screenshot_store_port.dart';
import '../../watch_history/domain/watch_history_repository.dart';
import '../../../shared/widgets/pp_toast.dart';
import 'widgets/player_layout.dart';
import 'widgets/player_ui_constants.dart';

Route<void> buildPlayerPageRoute({required Widget child}) {
  return buildPageTransitionRoute<void>(
    builder: (_) => child,
    type: PageTransitionType.none,
  );
}

class PlayerPage extends StatefulWidget {
  final List<PlayerQueueItem> playlist;
  final int initialIndex;
  final PlayerPlaybackPort? playbackPort;
  final PlayerDevicePort? devicePort;
  final PlayerScreenshotStorePort? screenshotStore;

  const PlayerPage({
    super.key,
    required this.playlist,
    this.initialIndex = 0,
    this.playbackPort,
    this.devicePort,
    this.screenshotStore,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  late final String _controllerTag;
  late final PlayerPlaybackPort _playbackPort;
  late final PlayerDevicePort _devicePort;
  late final PlayerScreenshotStorePort _screenshotStore;
  late final PlayerController _controller;
  Worker? _toastWorker;
  Future<void>? _persistProgressTask;
  bool _showEpisodePanel = false;
  bool _showFavoritePanel = false;
  bool _showMorePanel = false;
  bool _flipHorizontal = false;
  bool _flipVertical = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controllerTag = 'player_${identityHashCode(this)}';
    _playbackPort = widget.playbackPort ?? MediaKitPlaybackAdapter();
    _devicePort = widget.devicePort ?? PlayerDeviceAdapter();
    _screenshotStore =
        widget.screenshotStore ?? MethodChannelPlayerScreenshotStore();
    _controller = Get.put<PlayerController>(
      PlayerController(
        settingsController: Get.find<SettingsController>(),
        playbackPositionRepository: Get.find<PlaybackPositionRepository>(),
        watchHistoryRepository: Get.find<WatchHistoryRepository>(),
        playbackPort: _playbackPort,
        devicePort: _devicePort,
        screenshotStore: _screenshotStore,
        queue: widget.playlist,
        initialIndex: widget.initialIndex,
      ),
      tag: _controllerTag,
    );
    _toastWorker = ever<PlayerToastState?>(
      _controller.toastMessage,
      _handleToastMessage,
    );
    _enterImmersiveMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _toastWorker?.dispose();
    Get.delete<PlayerController>(tag: _controllerTag, force: true);
    _playbackPort.disposePlayback();
    _restoreSystemUi();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_controller.refreshDeviceSnapshot());
      return;
    }
    if (!_shouldPersistForLifecycle(state)) {
      return;
    }
    unawaited(_persistProgressIfNeeded());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope<void>(
        canPop: false,
        onPopInvokedWithResult: _handlePopInvoked,
        child: Scaffold(
          backgroundColor: kPlayerBackground,
          body: PlayerLayout(
            controller: _controller,
            playbackPort: _playbackPort,
            onBack: _handleBack,
            onOpenSettings: _openSettings,
            onSurfaceTap: _handleSurfaceTap,
            onToggleLock: _handleToggleLock,
            onShowEpisodePanel: _openEpisodePanel,
            onShowFavoritePanel: _openFavoritePanel,
            onShowMorePanel: _openMorePanel,
            onClosePanels: _closePanels,
            onCreateFavoriteFolder: _openCreateFavoriteFolderPage,
            onToggleHorizontalFlip: _toggleHorizontalFlip,
            onToggleVerticalFlip: _toggleVerticalFlip,
            showEpisodePanel: _showEpisodePanel,
            showFavoritePanel: _showFavoritePanel,
            showMorePanel: _showMorePanel,
            flipHorizontal: _flipHorizontal,
            flipVertical: _flipVertical,
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    Navigator.of(context).maybePop();
  }

  Future<bool> _handleWillPop() async {
    if (_showEpisodePanel || _showFavoritePanel || _showMorePanel) {
      _closePanels();
      return false;
    }
    if (_persistProgressTask != null) {
      return false;
    }

    await _persistProgressIfNeeded();
    return true;
  }

  Future<void> _handlePopInvoked(bool didPop, void _) async {
    if (didPop) {
      return;
    }
    final shouldPop = await _handleWillPop();
    if (!shouldPop || !mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _openSettings() async {
    await pushRootPage<void>(context, (_) => const PlayerSettingsPage());
  }

  void _enterImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  void _restoreSystemUi() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _persistProgressIfNeeded() async {
    final activeTask = _persistProgressTask;
    if (activeTask != null) {
      return activeTask;
    }

    final task = _controller.persistProgressBeforeExit();
    _persistProgressTask = task;
    try {
      await task;
    } finally {
      _persistProgressTask = null;
    }
  }

  bool _shouldPersistForLifecycle(AppLifecycleState state) {
    return state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached;
  }

  void _handleSurfaceTap() {
    if (_showEpisodePanel || _showFavoritePanel || _showMorePanel) {
      _closePanels();
      return;
    }
    _controller.handleSurfaceTap();
  }

  void _handleToggleLock() {
    _closePanels(armAutoHide: false);
    _controller.toggleLock();
  }

  void _openEpisodePanel() {
    _controller.showControls();
    _controller.cancelControlsAutoHide();
    setState(() {
      _showEpisodePanel = true;
      _showFavoritePanel = false;
      _showMorePanel = false;
    });
  }

  void _openFavoritePanel() {
    _controller.showControls();
    _controller.cancelControlsAutoHide();
    setState(() {
      _showEpisodePanel = false;
      _showFavoritePanel = true;
      _showMorePanel = false;
    });
  }

  void _openMorePanel() {
    _controller.showControls();
    _controller.cancelControlsAutoHide();
    setState(() {
      _showEpisodePanel = false;
      _showFavoritePanel = false;
      _showMorePanel = true;
    });
  }

  void _closePanels({bool armAutoHide = true}) {
    if (!_showEpisodePanel && !_showFavoritePanel && !_showMorePanel) {
      return;
    }
    setState(() {
      _showEpisodePanel = false;
      _showFavoritePanel = false;
      _showMorePanel = false;
    });
    if (armAutoHide) {
      _controller.armControlsAutoHide();
    }
  }

  void _toggleHorizontalFlip() {
    setState(() => _flipHorizontal = !_flipHorizontal);
  }

  void _toggleVerticalFlip() {
    setState(() => _flipVertical = !_flipVertical);
  }

  Future<FavoriteFolderEntry?> _openCreateFavoriteFolderPage() async {
    final favoritesController = Get.find<FavoritesController>();
    final title = await pushRootPage<String>(
      context,
      (_) => FavoriteFolderFormPage(
        existingTitles: favoritesController.existingTitles(),
      ),
    );
    if (!mounted || title == null) {
      return null;
    }

    return favoritesController.createFolder(title: title);
  }

  void _handleToastMessage(PlayerToastState? toast) {
    if (!mounted || toast == null || toast.message.isEmpty) {
      return;
    }

    switch (toast.kind) {
      case PlayerToastKind.neutral:
        PPToast.show(toast.message);
      case PlayerToastKind.success:
        PPToast.success(toast.message);
      case PlayerToastKind.error:
        PPToast.error(toast.message);
      case PlayerToastKind.warning:
        PPToast.warning(toast.message);
    }
    _controller.clearToastMessage();
  }
}
