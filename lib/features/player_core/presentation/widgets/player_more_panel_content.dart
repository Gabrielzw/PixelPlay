import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../settings/domain/app_settings.dart';
import '../../domain/player_controller.dart';
import 'player_more_panel_parts.dart';

class PlayerMorePanelContent extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onClose;
  final VoidCallback onOpenSettings;
  final VoidCallback onToggleHorizontalFlip;
  final VoidCallback onToggleVerticalFlip;
  final bool flipHorizontal;
  final bool flipVertical;

  const PlayerMorePanelContent({
    super.key,
    required this.controller,
    required this.onClose,
    required this.onOpenSettings,
    required this.onToggleHorizontalFlip,
    required this.onToggleVerticalFlip,
    required this.flipHorizontal,
    required this.flipVertical,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = controller.settingsController.settings.value;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _PlaybackModeSection(controller: controller, settings: settings),
          const SizedBox(height: 24),
          _AspectRatioSection(controller: controller),
          const SizedBox(height: 24),
          _TransformSection(
            flipHorizontal: flipHorizontal,
            flipVertical: flipVertical,
            onToggleHorizontalFlip: onToggleHorizontalFlip,
            onToggleVerticalFlip: onToggleVerticalFlip,
          ),
          const SizedBox(height: 24),
          _LongPressSpeedSection(controller: controller, settings: settings),
          const SizedBox(height: 24),
          _SeekSettingsSection(controller: controller, settings: settings),
          const SizedBox(height: 12),
          PlayerPanelSwitchRow(
            title: '自动播放',
            subtitle: '进入播放器页面后自动开始播放当前视频',
            value: settings.autoPlayOnEnter,
            onChanged: (bool enabled) =>
                controller.setAutoPlayOnEnter(enabled, showHud: false),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {
                onClose();
                onOpenSettings();
              },
              icon: const Icon(Icons.tune_rounded),
              label: const Text('打开播放器设置页'),
            ),
          ),
        ],
      );
    });
  }
}

class _PlaybackModeSection extends StatelessWidget {
  final PlayerController controller;
  final AppSettings settings;

  const _PlaybackModeSection({
    required this.controller,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const PlayerPanelSectionTitle('播放方式'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: PlayerPlaybackMode.values
              .map(
                (PlayerPlaybackMode mode) => PlayerPanelChoiceChipButton(
                  label: mode.label,
                  icon: mode.icon,
                  selected: settings.defaultPlaybackMode == mode,
                  onTap: () => controller.setPlaybackMode(mode, showHud: false),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _AspectRatioSection extends StatelessWidget {
  final PlayerController controller;

  const _AspectRatioSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const PlayerPanelSectionTitle('画面比例'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: PlayerAspectRatio.values
              .map(
                (PlayerAspectRatio ratio) => PlayerPanelChoiceChipButton(
                  label: ratio.label,
                  icon: ratio.icon,
                  selected: controller.aspectRatio.value == ratio,
                  onTap: () => controller.setAspectRatio(ratio, showHud: false),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _TransformSection extends StatelessWidget {
  final bool flipHorizontal;
  final bool flipVertical;
  final VoidCallback onToggleHorizontalFlip;
  final VoidCallback onToggleVerticalFlip;

  const _TransformSection({
    required this.flipHorizontal,
    required this.flipVertical,
    required this.onToggleHorizontalFlip,
    required this.onToggleVerticalFlip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const PlayerPanelSectionTitle('画面变换'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            PlayerPanelChoiceChipButton(
              label: '水平翻转',
              icon: Icons.flip_rounded,
              selected: flipHorizontal,
              onTap: onToggleHorizontalFlip,
            ),
            PlayerPanelChoiceChipButton(
              label: '垂直翻转',
              icon: Icons.flip_camera_android_rounded,
              selected: flipVertical,
              onTap: onToggleVerticalFlip,
            ),
          ],
        ),
      ],
    );
  }
}

class _LongPressSpeedSection extends StatelessWidget {
  final PlayerController controller;
  final AppSettings settings;

  const _LongPressSpeedSection({
    required this.controller,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const PlayerPanelSectionTitle('长按倍速'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: kLongPressSpeedOptions
              .map(
                (double speed) => PlayerPanelChoiceChipButton(
                  label: '${speed}x',
                  icon: Icons.speed_rounded,
                  selected: settings.longPressPlaybackSpeed == speed,
                  onTap: () => controller.setLongPressPlaybackSpeed(
                    speed,
                    showHud: false,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _SeekSettingsSection extends StatelessWidget {
  final PlayerController controller;
  final AppSettings settings;

  const _SeekSettingsSection({
    required this.controller,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PlayerPanelSwitchRow(
          title: '按视频总时长拖动',
          subtitle: '开启后，横向滑动将按视频总时长比例快进快退',
          value: settings.gestureSeekUsesVideoDuration,
          onChanged: (bool enabled) => controller
              .setGestureSeekUsesVideoDuration(enabled, showHud: false),
        ),
        const SizedBox(height: 24),
        Text(
          '整屏滑动对应时长：${settings.gestureSeekSecondsPerSwipe}s',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: settings.gestureSeekSecondsPerSwipe.toDouble(),
          min: kGestureSeekMinSeconds.toDouble(),
          max: kGestureSeekMaxSeconds.toDouble(),
          divisions: kGestureSeekDivisions,
          label: '${settings.gestureSeekSecondsPerSwipe}s',
          onChanged: (double next) {
            controller.settingsController.setGestureSeekSecondsPerSwipe(
              next.round(),
            );
          },
        ),
      ],
    );
  }
}
