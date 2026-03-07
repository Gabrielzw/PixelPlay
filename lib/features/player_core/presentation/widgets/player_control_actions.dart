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
const double _kWideTopBarMinWidth = 720;

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
      final mediaQuery = MediaQuery.of(context);
      final orientation = mediaQuery.orientation;
      final isLandscape = orientation == Orientation.landscape;
      final showScreenshotAction = _shouldShowScreenshotAction(
        mediaQuery.size,
        orientation,
      );

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
              onScreenshot: controller.showScreenshotUnavailable,
              showScreenshotAction: showScreenshotAction,
            ),
          ],
        ),
      );
    });
  }

  bool _shouldShowScreenshotAction(Size size, Orientation orientation) {
    return orientation == Orientation.landscape ||
        size.width >= _kWideTopBarMinWidth;
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
  final VoidCallback onScreenshot;
  final bool showScreenshotAction;

  const _PlayerTopMainRow({
    required this.title,
    required this.onBack,
    required this.onShowMore,
    required this.onScreenshot,
    required this.showScreenshotAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _PlayerTopBarButton(
          icon: Icons.arrow_back_rounded,
          tooltip: '返回',
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
        if (showScreenshotAction) ...<Widget>[
          const SizedBox(width: _kTopBarActionSpacing),
          _PlayerTopBarButton(
            icon: Icons.photo_camera_outlined,
            tooltip: '截图',
            onPressed: onScreenshot,
          ),
        ],
        const SizedBox(width: _kTopBarActionSpacing),
        _PlayerTopBarButton(
          icon: Icons.more_horiz_rounded,
          tooltip: '更多',
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
