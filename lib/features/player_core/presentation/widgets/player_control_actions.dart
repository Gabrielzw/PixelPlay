import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/player_controller.dart';
import 'player_device_status_strip.dart';
import 'player_ui_constants.dart';

const double _kTopBarHorizontalPadding = 16;
const double _kTopBarPortraitTopPadding = 8;
const double _kTopBarLandscapeTopPadding = 6;
const double _kTopBarBottomPadding = 6;
const double _kTopBarButtonSize = 34;
const double _kTopBarButtonIconSize = 22;
const double _kTopBarStatusSpacing = 4;
const double _kTopBarActionSpacing = 6;
const double kPlayerSideActionHorizontalPadding = 12;
const double _kSideActionBackgroundOpacity = 0.42;
const double _kSideActionBorderRadius = 20;

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
        padding: EdgeInsets.fromLTRB(
          _kTopBarHorizontalPadding,
          isLandscape
              ? _kTopBarLandscapeTopPadding
              : _kTopBarPortraitTopPadding,
          _kTopBarHorizontalPadding,
          _kTopBarBottomPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _PlayerTopStatusRow(controller: controller),
            const SizedBox(height: _kTopBarStatusSpacing),
            _PlayerTopMainRow(
              title: item.title,
              onBack: onBack,
              onShowMore: onShowMore,
            ),
          ],
        ),
      );
    });
  }
}

class _PlayerTopStatusRow extends StatelessWidget {
  final PlayerController controller;

  const _PlayerTopStatusRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: PlayerDeviceStatusStrip(controller: controller),
      ),
    );
  }
}

class _PlayerTopMainRow extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onShowMore;

  const _PlayerTopMainRow({
    required this.title,
    required this.onBack,
    required this.onShowMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _PlayerTopBarButton(
          icon: Icons.arrow_back_rounded,
          tooltip: '\u8fd4\u56de',
          onPressed: onBack,
        ),
        const SizedBox(width: _kTopBarActionSpacing),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: _kTopBarActionSpacing),
        _PlayerTopBarButton(
          icon: Icons.more_horiz_rounded,
          tooltip: '\u66f4\u591a',
          onPressed: onShowMore,
        ),
      ],
    );
  }
}

class _PlayerTopBarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _PlayerTopBarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _kTopBarButtonSize,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          minimumSize: const Size.square(_kTopBarButtonSize),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        color: Colors.white,
        icon: Icon(icon, size: _kTopBarButtonIconSize),
      ),
    );
  }
}

class PlayerLockedOverlay extends StatelessWidget {
  final VoidCallback onUnlock;

  const PlayerLockedOverlay({super.key, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return PlayerSideSafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: PlayerSideLockButton(isLocked: true, onPressed: onUnlock),
      ),
    );
  }
}

class PlayerSideSafeArea extends StatelessWidget {
  final Widget child;

  const PlayerSideSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.symmetric(
        horizontal: kPlayerSideActionHorizontalPadding,
      ),
      child: child,
    );
  }
}

class PlayerSideScreenshotButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlayerSideScreenshotButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return _PlayerSideActionButton(
      tooltip: '\u622a\u56fe',
      icon: Icons.photo_camera_outlined,
      onPressed: onPressed,
    );
  }
}

class _PlayerSideActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  const _PlayerSideActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: applyOpacity(Colors.black, _kSideActionBackgroundOpacity),
        borderRadius: const BorderRadius.all(
          Radius.circular(_kSideActionBorderRadius),
        ),
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
        color: Colors.white,
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
    return _PlayerSideActionButton(
      tooltip: isLocked ? '\u89e3\u9501' : '\u9501\u5b9a',
      icon: isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
      onPressed: onPressed,
    );
  }
}
