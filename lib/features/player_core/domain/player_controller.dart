import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../settings/domain/app_settings.dart';
import '../../settings/domain/settings_controller.dart';
import 'playback_position_repository.dart';
import 'player_device_port.dart';
import 'player_playback_port.dart';
import 'player_queue_item.dart';
import 'player_screenshot_store_port.dart';
import 'player_video_metadata.dart';

part 'player_controller_commands.dart';
part 'player_controller_state.dart';
part 'player_controller_gestures.dart';
part 'player_controller_device.dart';
part 'player_controller_playback.dart';
part 'player_controller_preferences.dart';
part 'player_controller_screenshot.dart';
part 'player_controller_visibility.dart';

class PlayerController extends GetxController {
  final SettingsController settingsController;
  final PlaybackPositionRepository playbackPositionRepository;
  final PlayerPlaybackPort playbackPort;
  final PlayerDevicePort devicePort;
  final PlayerScreenshotStorePort screenshotStore;
  final List<PlayerQueueItem> queue;

  final RxBool isPlaying = true.obs;
  final RxBool controlsVisible = false.obs;
  final RxBool controlsLocked = false.obs;
  final RxBool isBuffering = false.obs;
  final RxBool isCapturingScreenshot = false.obs;
  final RxBool isCharging = false.obs;
  final RxDouble progress = 0.0.obs;
  final RxDouble brightnessLevel = kGestureDefaultLevel.obs;
  final RxDouble volumeLevel = kGestureDefaultLevel.obs;
  final RxDouble playbackSpeed = 1.0.obs;
  final RxInt batteryLevel = 100.obs;
  final RxInt currentIndex = 0.obs;
  final RxString currentTimeText = '--:--'.obs;
  final Rxn<PlayerHudState> hudState = Rxn<PlayerHudState>();
  final RxnString errorMessage = RxnString();
  final RxnString toastMessage = RxnString();
  final Rx<PlayerNetworkStatus> networkStatus = PlayerNetworkStatus.unknown.obs;
  final Rx<Matrix4> videoTransform = Matrix4.identity().obs;

  late final Rx<PlayerQueueItem> currentItem;
  late final Rx<Duration> position;
  late final Rx<Duration> duration;
  late final Rx<PlayerAspectRatio> aspectRatio;

  final List<StreamSubscription<Object?>> _playbackSubscriptions =
      <StreamSubscription<Object?>>[];

  Timer? _controlsTimer;
  Timer? _hudTimer;
  Timer? _progressSaveTimer;
  _PlayerGestureSession? _gestureSession;
  Duration? _pendingSeekPosition;
  Duration? _pendingRestorePosition;
  DateTime? _lastPositionSyncAt;
  Duration _lastSyncedPosition = Duration.zero;
  Duration _latestObservedPosition = Duration.zero;
  PlayerVideoOrientation _appliedVideoOrientation =
      PlayerVideoOrientation.unknown;
  bool _isOpeningCurrentItem = false;
  double? _speedBeforeLongPress;
  bool _isLongPressSpeedActive = false;

  PlayerController({
    required this.settingsController,
    required this.playbackPositionRepository,
    required this.playbackPort,
    required this.devicePort,
    required this.screenshotStore,
    required List<PlayerQueueItem> queue,
    int initialIndex = 0,
  }) : queue = List<PlayerQueueItem>.unmodifiable(queue) {
    if (this.queue.isEmpty) {
      throw ArgumentError.value(
        queue,
        'queue',
        'Player queue must not be empty.',
      );
    }

    final safeIndex = initialIndex.clamp(0, this.queue.length - 1);
    final initialItem = this.queue[safeIndex];
    final settings = settingsController.settings.value;

    currentIndex.value = safeIndex;
    currentItem = initialItem.obs;
    position = Duration.zero.obs;
    duration = initialItem.duration.obs;
    aspectRatio = settings.defaultAspectRatio.obs;
    playbackSpeed.value = settings.defaultPlaybackSpeed;
  }

  bool get hasPrevious => currentIndex.value > 0;

  bool get hasNext => currentIndex.value < queue.length - 1;

  bool get hasKnownDuration => duration.value > Duration.zero;

  bool get isNetworkError => currentItem.value.isRemote;

  @override
  Future<void> onReady() async {
    super.onReady();
    _bindPlaybackStreams();
    await bindDeviceFeatures();
    await _syncPlaybackPreferences();
    await openCurrentItem(
      restoreProgress: true,
      showRestoreMessage: true,
      autoPlay: appSettings.autoPlayOnEnter,
    );
    armControlsAutoHide();
  }

  @override
  void onClose() {
    unawaited(persistCurrentProgress());
    unawaited(devicePort.detach());
    _controlsTimer?.cancel();
    _hudTimer?.cancel();
    _progressSaveTimer?.cancel();
    for (final subscription in _playbackSubscriptions) {
      subscription.cancel();
    }
    super.onClose();
  }
}
