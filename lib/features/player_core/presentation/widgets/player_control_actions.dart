import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../favorites/presentation/controllers/favorites_controller.dart';
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
const double _kSideActionLoadingSize = 22;
const Color _kPlayerFavoritedIconColor = Color(0xFFFF6B81);

class PlayerControlActions extends StatelessWidget {
  final PlayerController controller;
  final FavoritesController favoritesController;
  final VoidCallback onBack;
  final VoidCallback onShowFavorite;
  final VoidCallback onShowMore;

  const PlayerControlActions({
    super.key,
    required this.controller,
    required this.favoritesController,
    required this.onBack,
    required this.onShowFavorite,
    required this.onShowMore,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.currentItem.value;
      final isFavorited = favoritesController.containsPlayerItem(item);
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
              isFavorited: isFavorited,
              onBack: onBack,
              onShowFavorite: onShowFavorite,
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
  final bool isFavorited;
  final VoidCallback onBack;
  final VoidCallback onShowFavorite;
  final VoidCallback onShowMore;

  const _PlayerTopMainRow({
    required this.title,
    required this.isFavorited,
    required this.onBack,
    required this.onShowFavorite,
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
          icon: isFavorited
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          tooltip: isFavorited ? '已收藏' : '收藏',
          onPressed: onShowFavorite,
          color: isFavorited ? _kPlayerFavoritedIconColor : Colors.white,
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
  final Color color;

  const _PlayerTopBarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = Colors.white,
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
        color: color,
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
  final bool isLoading;
  final VoidCallback onPressed;

  const PlayerSideScreenshotButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _PlayerSideActionButton(
      tooltip: '\u622a\u56fe',
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? LoadingAnimationWidget.threeArchedCircle(
              color: Theme.of(context).colorScheme.primary,
              size: _kSideActionLoadingSize,
            )
          : const Icon(Icons.photo_camera_outlined),
    );
  }
}

class _PlayerSideActionButton extends StatelessWidget {
  final String tooltip;
  final Widget child;
  final VoidCallback? onPressed;

  const _PlayerSideActionButton({
    required this.tooltip,
    required this.child,
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
        icon: child,
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
      onPressed: onPressed,
      child: Icon(isLocked ? Icons.lock_rounded : Icons.lock_open_rounded),
    );
  }
}
