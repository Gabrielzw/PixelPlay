import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import 'player_ui_constants.dart';

class PlayerFeedbackLayer extends StatelessWidget {
  final PlayerController controller;
  final VoidCallback onBack;

  const PlayerFeedbackLayer({
    super.key,
    required this.controller,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: <Widget>[
          if (controller.hudState.value != null)
            IgnorePointer(
              child: _HudOverlay(state: controller.hudState.value!),
            ),
          if (controller.isBuffering.value)
            const IgnorePointer(child: _BufferingOverlay()),
          if (controller.errorMessage.value != null)
            _ErrorOverlay(
              message: controller.errorMessage.value!,
              canRetry: controller.isNetworkError,
              onRetry: controller.retryCurrentItem,
              onBack: onBack,
            ),
        ],
      ),
    );
  }
}

class _HudOverlay extends StatelessWidget {
  final PlayerHudState state;

  const _HudOverlay({required this.state});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: state.alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: applyOpacity(Colors.black, 0.7),
          borderRadius: const BorderRadius.all(Radius.circular(999)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(_resolveHudIcon(state.kind), color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              state.primaryText,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _resolveHudIcon(PlayerHudKind kind) {
    return switch (kind) {
      PlayerHudKind.brightness => Icons.brightness_6_rounded,
      PlayerHudKind.volume => Icons.volume_up_rounded,
      PlayerHudKind.seek => Icons.fast_forward_rounded,
      PlayerHudKind.info => Icons.info_outline_rounded,
      PlayerHudKind.speed => Icons.speed_rounded,
    };
  }
}

class _BufferingOverlay extends StatelessWidget {
  const _BufferingOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: applyOpacity(Colors.black, 0.58),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 12),
              Text('加载中...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorOverlay extends StatelessWidget {
  final String message;
  final bool canRetry;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _ErrorOverlay({
    required this.message,
    required this.canRetry,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: applyOpacity(Colors.black, 0.78),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.error_outline_rounded,
                  size: 42,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (canRetry)
                      FilledButton(onPressed: onRetry, child: const Text('重试')),
                    if (canRetry) const SizedBox(width: 12),
                    OutlinedButton(onPressed: onBack, child: const Text('退出')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
