import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../domain/player_controller.dart';
import 'player_ui_constants.dart';

const double _kHudHorizontalMargin = 16;
const double _kHudHorizontalPadding = 14;
const double _kHudVerticalPadding = 10;
const double _kHudIconSize = 16;
const double _kHudIconSpacing = 8;
const double _kHudTextMaxWidth = 240;
const double _kBufferingOverlayOpacity = 0.58;
const double _kBufferingOverlayRadius = 18;
const double _kBufferingOverlayPadding = 20;
const double _kBufferingIndicatorSize = 42;
const double _kBufferingTextSpacing = 12;

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
          if (controller.hasActiveVideoTransform &&
              !controller.controlsLocked.value)
            Positioned(
              left: 0,
              right: 0,
              bottom: 104,
              child: AnimatedOpacity(
                opacity: controller.controlsVisible.value ? 1 : 0,
                duration: kPlayerOverlayAnimationDuration,
                child: IgnorePointer(
                  ignoring: !controller.controlsVisible.value,
                  child: Center(
                    child: FilledButton.icon(
                      onPressed: controller.resetVideoTransform,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('\u8fd8\u539f\u753b\u9762'),
                    ),
                  ),
                ),
              ),
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
    final icon = _resolveHudIcon(state.kind);
    return Align(
      alignment: _resolveHudAlignment(state),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: _kHudHorizontalMargin),
        padding: const EdgeInsets.symmetric(
          horizontal: _kHudHorizontalPadding,
          vertical: _kHudVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: applyOpacity(Colors.black, 0.7),
          borderRadius: const BorderRadius.all(Radius.circular(999)),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kHudTextMaxWidth),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, color: Colors.white, size: _kHudIconSize),
                const SizedBox(width: _kHudIconSpacing),
              ],
              Flexible(
                child: Text(
                  state.primaryText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Alignment _resolveHudAlignment(PlayerHudState state) {
    return switch (state.kind) {
      PlayerHudKind.brightness => const Alignment(
        0,
        kPlayerInteractionHudAlignmentY,
      ),
      PlayerHudKind.volume => const Alignment(
        0,
        kPlayerInteractionHudAlignmentY,
      ),
      PlayerHudKind.seek => const Alignment(0, kPlayerInteractionHudAlignmentY),
      PlayerHudKind.speed => const Alignment(
        0,
        kPlayerInteractionHudAlignmentY,
      ),
      PlayerHudKind.info => state.alignment,
    };
  }

  IconData? _resolveHudIcon(PlayerHudKind kind) {
    return switch (kind) {
      PlayerHudKind.brightness => Icons.brightness_6_rounded,
      PlayerHudKind.volume => Icons.volume_up_rounded,
      PlayerHudKind.seek => null,
      PlayerHudKind.info => Icons.info_outline_rounded,
      PlayerHudKind.speed => Icons.speed_rounded,
    };
  }
}

class _BufferingOverlay extends StatelessWidget {
  const _BufferingOverlay();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: applyOpacity(Colors.black, _kBufferingOverlayOpacity),
          borderRadius: const BorderRadius.all(
            Radius.circular(_kBufferingOverlayRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_kBufferingOverlayPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoadingAnimationWidget.progressiveDots(
                color: primaryColor,
                size: _kBufferingIndicatorSize,
              ),
              const SizedBox(height: _kBufferingTextSpacing),
              const Text(
                '\u52a0\u8f7d\u4e2d...',
                style: TextStyle(color: Colors.white),
              ),
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
                      FilledButton(
                        onPressed: onRetry,
                        child: const Text('\u91cd\u8bd5'),
                      ),
                    if (canRetry) const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: onBack,
                      child: const Text('\u9000\u51fa'),
                    ),
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
