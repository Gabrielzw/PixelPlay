import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import 'player_ui_constants.dart';

class PlayerControlActions extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onBack;
  final VoidCallback onShowMore;

  const PlayerControlActions({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onShowMore,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.currentItem.value;
      final isLandscape =
          MediaQuery.of(context).orientation == Orientation.landscape;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
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
            if (isLandscape) const _CurrentTimeLabel(),
            if (isLandscape) const SizedBox(width: 8),
            IconButton(
              tooltip: '截图',
              onPressed: controller.showScreenshotUnavailable,
              icon: const Icon(Icons.photo_camera_outlined),
              color: Colors.white,
            ),
            IconButton(
              tooltip: '更多',
              onPressed: onShowMore,
              icon: const Icon(Icons.more_vert_rounded),
              color: Colors.white,
            ),
          ],
        ),
      );
    });
  }
}

class _CurrentTimeLabel extends StatefulWidget {
  const _CurrentTimeLabel();

  @override
  State<_CurrentTimeLabel> createState() => _CurrentTimeLabelState();
}

class _CurrentTimeLabelState extends State<_CurrentTimeLabel> {
  late String _timeText;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeText = _formatNow();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _timeText = _formatNow());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeText,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _formatNow() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
        tooltip: isLocked ? '解锁' : '锁定',
        onPressed: onPressed,
        icon: Icon(isLocked ? Icons.lock_rounded : Icons.lock_open_rounded),
        color: Colors.white,
      ),
    );
  }
}
