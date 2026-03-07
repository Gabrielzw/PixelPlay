import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../settings/domain/app_settings.dart';
import '../../domain/player_controller.dart';
import 'player_more_panel_parts.dart';
import 'player_slide_panel.dart';
import 'player_ui_constants.dart';

class PlayerMorePanel extends StatelessWidget {
  final PlayerController controller;
  final bool visible;
  final VoidCallback onClose;
  final VoidCallback onOpenSettings;
  final VoidCallback onToggleHorizontalFlip;
  final VoidCallback onToggleVerticalFlip;
  final bool flipHorizontal;
  final bool flipVertical;

  const PlayerMorePanel({
    super.key,
    required this.controller,
    required this.visible,
    required this.onClose,
    required this.onOpenSettings,
    required this.onToggleHorizontalFlip,
    required this.onToggleVerticalFlip,
    required this.flipHorizontal,
    required this.flipVertical,
  });

  @override
  Widget build(BuildContext context) {
    return PlayerSlidePanel(
      visible: visible,
      landscapeWidth: 380,
      portraitHeightFactor: 0.68,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: applyOpacity(Colors.black, 0.94),
          borderRadius: _resolveRadius(context),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.black45, blurRadius: 18),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
              child: Row(
                children: <Widget>[
                  Text(
                    '更多设置',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white12),
            Expanded(
              child: Obx(() {
                final settings = controller.settingsController.settings.value;
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    const PlayerPanelSectionTitle('播放方式'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PlayerPlaybackMode.values
                          .map(
                            (PlayerPlaybackMode mode) =>
                                PlayerPanelChoiceChipButton(
                                  label: mode.label,
                                  icon: mode.icon,
                                  selected:
                                      settings.defaultPlaybackMode == mode,
                                  onTap: () => controller.setPlaybackMode(mode),
                                ),
                          )
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 24),
                    const PlayerPanelSectionTitle('画面比例'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PlayerAspectRatio.values
                          .map(
                            (PlayerAspectRatio ratio) =>
                                PlayerPanelChoiceChipButton(
                                  label: ratio.label,
                                  icon: ratio.icon,
                                  selected:
                                      controller.aspectRatio.value == ratio,
                                  onTap: () => controller.setAspectRatio(ratio),
                                ),
                          )
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 24),
                    const PlayerPanelSectionTitle('长按倍速'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kLongPressSpeedOptions
                          .map(
                            (double speed) => PlayerPanelChoiceChipButton(
                              label: '${speed}x',
                              icon: Icons.speed_rounded,
                              selected:
                                  settings.longPressPlaybackSpeed == speed,
                              onTap: () =>
                                  controller.setLongPressPlaybackSpeed(speed),
                            ),
                          )
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 24),
                    PlayerPanelSwitchRow(
                      title: '按视频总时长拖动',
                      subtitle: '开启后，横向滑动将按视频总时长比例快进快退',
                      value: settings.gestureSeekUsesVideoDuration,
                      onChanged: controller.setGestureSeekUsesVideoDuration,
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
                        controller.settingsController
                            .setGestureSeekSecondsPerSwipe(next.round());
                      },
                    ),
                    const SizedBox(height: 12),
                    PlayerPanelSwitchRow(
                      title: '自动连播',
                      subtitle: '视频播放完成后自动跳到下一集',
                      value: settings.autoPlayNext,
                      onChanged: controller.settingsController.setAutoPlayNext,
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
              }),
            ),
          ],
        ),
      ),
    );
  }

  BorderRadius _resolveRadius(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape
        ? const BorderRadius.horizontal(left: Radius.circular(18))
        : const BorderRadius.vertical(top: Radius.circular(18));
  }
}
