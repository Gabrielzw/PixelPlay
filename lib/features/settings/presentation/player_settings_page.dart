import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/settings/settings_choice_sheet.dart';
import '../../../shared/widgets/settings/settings_shell.dart';
import '../domain/app_settings.dart';
import '../domain/settings_controller.dart';

class PlayerSettingsPage extends GetView<SettingsController> {
  const PlayerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = controller.settings.value;

      return SettingsDetailScaffold(
        title: '播放器设置',
        child: ListView(
          padding: kSettingsPagePadding,
          children: <Widget>[
            const SettingsSectionTitle('常规播放'),
            SettingsListItem(
              title: '默认倍速',
              subtitle: '${settings.defaultPlaybackSpeed}x',
              onTap: () => _selectDefaultPlaybackSpeed(context, settings),
            ),
            SettingsSwitchItem(
              title: '自动播放',
              subtitle: '进入视频详情或切换视频时自动开始播放',
              value: settings.autoPlayOnEnter,
              onChanged: controller.setAutoPlayOnEnter,
            ),
            SettingsSwitchItem(
              title: '退出后恢复进度',
              subtitle: '再次打开同一视频时从上次播放位置继续',
              value: settings.rememberPlaybackPosition,
              onChanged: controller.setRememberPlaybackPosition,
            ),
            SettingsListItem(
              title: '默认播放模式',
              subtitle: settings.defaultPlaybackMode.label,
              onTap: () => _selectDefaultPlaybackMode(context, settings),
            ),
            const SizedBox(height: kSettingsSectionSpacing),
            const SettingsSectionTitle('画面与显示'),
            SettingsListItem(
              title: '默认画面比例',
              subtitle: settings.defaultAspectRatio.label,
              onTap: () => _selectAspectRatio(context, settings),
            ),
            const SizedBox(height: kSettingsSectionSpacing),
            const SettingsSectionTitle('手势与操控'),
            SettingsListItem(
              title: '长按倍速',
              subtitle: '${settings.longPressPlaybackSpeed}x',
              onTap: () => _selectLongPressSpeed(context, settings),
            ),
            SettingsSwitchItem(
              title: '使用相对时长拖动',
              subtitle: '根据滑动距离相对于屏幕宽度的比例来调整进度',
              value: settings.gestureSeekUsesVideoDuration,
              onChanged: controller.setGestureSeekUsesVideoDuration,
            ),
            SettingsListItem(
              title: '全屏滑动对应时长',
              subtitle:
                  '从屏幕左侧滑到右侧对应的快进时长：'
                  '${settings.gestureSeekSecondsPerSwipe} 秒',
              onTap: () => _selectGestureSeekSeconds(context, settings),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _selectDefaultPlaybackSpeed(
    BuildContext context,
    AppSettings settings,
  ) async {
    final next = await showSettingsChoiceSheet<double>(
      context: context,
      title: '默认倍速',
      description: '播放器打开后默认使用的倍速。',
      selectedValue: settings.defaultPlaybackSpeed,
      options: kPlaybackSpeedOptions
          .map((double speed) {
            return SettingsChoiceOption<double>(
              value: speed,
              title: '${speed}x',
              subtitle: speed == 1.0 ? '标准播放速度' : null,
            );
          })
          .toList(growable: false),
    );

    if (next == null) {
      return;
    }

    await controller.setDefaultPlaybackSpeed(next);
  }

  Future<void> _selectDefaultPlaybackMode(
    BuildContext context,
    AppSettings settings,
  ) async {
    final next = await showSettingsChoiceSheet<PlayerPlaybackMode>(
      context: context,
      title: '默认播放模式',
      description: '视频播完后的默认处理方式。',
      selectedValue: settings.defaultPlaybackMode,
      options: PlayerPlaybackMode.values
          .map((PlayerPlaybackMode mode) {
            return SettingsChoiceOption<PlayerPlaybackMode>(
              value: mode,
              title: mode.label,
              icon: mode.icon,
            );
          })
          .toList(growable: false),
    );

    if (next == null) {
      return;
    }

    await controller.setDefaultPlaybackMode(next);
  }

  Future<void> _selectAspectRatio(
    BuildContext context,
    AppSettings settings,
  ) async {
    final next = await showSettingsChoiceSheet<PlayerAspectRatio>(
      context: context,
      title: '默认画面比例',
      description: '新视频进入播放器时默认使用的显示方式。',
      selectedValue: settings.defaultAspectRatio,
      options: PlayerAspectRatio.values
          .map((PlayerAspectRatio ratio) {
            return SettingsChoiceOption<PlayerAspectRatio>(
              value: ratio,
              title: ratio.label,
              icon: ratio.icon,
            );
          })
          .toList(growable: false),
    );

    if (next == null) {
      return;
    }

    await controller.setDefaultAspectRatio(next);
  }

  Future<void> _selectLongPressSpeed(
    BuildContext context,
    AppSettings settings,
  ) async {
    final next = await showSettingsChoiceSheet<double>(
      context: context,
      title: '长按倍速',
      description: '长按播放器时临时使用的加速倍速。',
      selectedValue: settings.longPressPlaybackSpeed,
      options: kLongPressSpeedOptions
          .map((double speed) {
            return SettingsChoiceOption<double>(
              value: speed,
              title: '${speed}x',
            );
          })
          .toList(growable: false),
    );

    if (next == null) {
      return;
    }

    await controller.setLongPressPlaybackSpeed(next);
  }

  Future<void> _selectGestureSeekSeconds(
    BuildContext context,
    AppSettings settings,
  ) async {
    final options = List<int>.generate(
      kGestureSeekDivisions + 1,
      (int index) => kGestureSeekMinSeconds + index * kGestureSeekStepSeconds,
      growable: false,
    );
    final next = await showSettingsChoiceSheet<int>(
      context: context,
      title: '全屏滑动对应时长',
      description: '关闭相对时长拖动后，横向滑动会按这里的秒数快进快退。',
      selectedValue: settings.gestureSeekSecondsPerSwipe,
      options: options
          .map((int seconds) {
            return SettingsChoiceOption<int>(
              value: seconds,
              title: '$seconds 秒',
            );
          })
          .toList(growable: false),
    );

    if (next == null) {
      return;
    }

    await controller.setGestureSeekSecondsPerSwipe(next);
  }
}
