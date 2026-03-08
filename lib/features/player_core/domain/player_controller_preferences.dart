part of 'player_controller.dart';

extension PlayerControllerPreferences on PlayerController {
  AppSettings get appSettings => settingsController.settings.value;

  Future<void> seekTo(Duration position) async {
    previewSeekPosition(position);
    await commitSeekPreview();
  }

  Future<void> setPlaybackMode(PlayerPlaybackMode mode) async {
    await settingsController.setDefaultPlaybackMode(mode);
    showInfoHud('播放方式：${mode.label}');
    armControlsAutoHide();
  }

  Future<void> setAutoPlayOnEnter(bool enabled) async {
    await settingsController.setAutoPlayOnEnter(enabled);
    final message = enabled ? '进入播放器后自动播放' : '进入播放器后暂停等待';
    showInfoHud(message);
    armControlsAutoHide();
  }

  Future<void> setLongPressPlaybackSpeed(double speed) async {
    await settingsController.setLongPressPlaybackSpeed(speed);
    showInfoHud('长按倍速 ${speed}x');
    armControlsAutoHide();
  }

  Future<void> setGestureSeekUsesVideoDuration(bool enabled) async {
    await settingsController.setGestureSeekUsesVideoDuration(enabled);
    final message = enabled ? '滑动快进按视频总时长' : '滑动快进按固定时长';
    showInfoHud(message);
    armControlsAutoHide();
  }

  Future<void> beginLongPressSpeedBoost() async {
    if (_isLongPressSpeedActive || !isPlaying.value || controlsLocked.value) {
      return;
    }
    _isLongPressSpeedActive = true;
    _speedBeforeLongPress = playbackSpeed.value;
    final targetSpeed = appSettings.longPressPlaybackSpeed;
    await playbackPort.setPlaybackSpeed(targetSpeed);
    showHud(
      PlayerHudState(
        kind: PlayerHudKind.speed,
        primaryText: '${targetSpeed}x 长按倍速',
      ),
    );
  }

  Future<void> endLongPressSpeedBoost() async {
    if (!_isLongPressSpeedActive) {
      return;
    }
    _isLongPressSpeedActive = false;
    final restoreSpeed = _speedBeforeLongPress ?? playbackSpeed.value;
    _speedBeforeLongPress = null;
    await playbackPort.setPlaybackSpeed(restoreSpeed);
    hudState.value = null;
    armControlsAutoHide();
  }
}
