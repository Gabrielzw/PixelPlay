import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import 'player_ui_constants.dart';

enum _PlayerMenuAction { openSettings, resetProgress }

class PlayerControlActions extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onBack;
  final VoidCallback onOpenSettings;

  const PlayerControlActions({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.currentItem.value;
      return Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              applyOpacity(Colors.black, kPlayerTopGradientStartOpacity),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: '返回',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              color: Colors.white,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    item.sourceLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: '截图',
              onPressed: controller.showScreenshotUnavailable,
              icon: const Icon(Icons.photo_camera_outlined),
              color: Colors.white,
            ),
            PopupMenuButton<_PlayerMenuAction>(
              tooltip: '更多',
              onSelected: (_PlayerMenuAction action) {
                switch (action) {
                  case _PlayerMenuAction.openSettings:
                    onOpenSettings();
                    return;
                  case _PlayerMenuAction.resetProgress:
                    controller.resetCurrentProgress();
                    return;
                }
              },
              itemBuilder: (BuildContext context) {
                return const <PopupMenuEntry<_PlayerMenuAction>>[
                  PopupMenuItem<_PlayerMenuAction>(
                    value: _PlayerMenuAction.openSettings,
                    child: Text('播放器默认设置'),
                  ),
                  PopupMenuItem<_PlayerMenuAction>(
                    value: _PlayerMenuAction.resetProgress,
                    child: Text('重置当前进度'),
                  ),
                ];
              },
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            ),
          ],
        ),
      );
    });
  }
}

class PlayerPlayPauseButton extends StatelessWidget {
  final PlayerController controller;

  const PlayerPlayPauseButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FilledButton.tonal(
        onPressed: controller.togglePlay,
        style: FilledButton.styleFrom(
          minimumSize: const Size(72, 72),
          backgroundColor: applyOpacity(Colors.white, 0.16),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
        ),
        child: Icon(
          controller.isPlaying.value
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          size: 36,
        ),
      ),
    );
  }
}

class PlayerLockedOverlay extends StatelessWidget {
  final VoidCallback onUnlock;

  const PlayerLockedOverlay({super.key, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: PlayerSideLockButton(isLocked: true, onPressed: onUnlock),
        ),
      ),
    );
  }
}

class PlayerSideLockButton extends StatelessWidget {
  final bool isLocked;
  final VoidCallback onPressed;

  const PlayerSideLockButton({
    super.key,
    required this.isLocked,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: applyOpacity(Colors.black, 0.42),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: IconButton(
        tooltip: isLocked ? '解锁' : '锁屏',
        onPressed: onPressed,
        icon: Icon(isLocked ? Icons.lock_rounded : Icons.lock_open_rounded),
        color: Colors.white,
      ),
    );
  }
}
