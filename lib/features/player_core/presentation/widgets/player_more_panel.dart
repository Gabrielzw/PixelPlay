import 'package:flutter/material.dart';

import '../../domain/player_controller.dart';
import 'player_more_panel_content.dart';
import 'player_slide_panel.dart';
import 'player_ui_constants.dart';

const double _kMorePanelOpacity = 0.94;
const double _kMorePanelLandscapeWidth = 380;
const double _kMorePanelPortraitHeightFactor = 0.68;
const double _kMorePanelBlurRadius = 18;

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
      landscapeWidth: _kMorePanelLandscapeWidth,
      portraitHeightFactor: _kMorePanelPortraitHeightFactor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: applyOpacity(Colors.black, _kMorePanelOpacity),
          borderRadius: _resolveRadius(context),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.black45, blurRadius: _kMorePanelBlurRadius),
          ],
        ),
        child: Column(
          children: <Widget>[
            _PlayerMorePanelHeader(onClose: onClose),
            const Divider(height: 1, color: Colors.white12),
            Expanded(
              child: PlayerMorePanelContent(
                controller: controller,
                onClose: onClose,
                onOpenSettings: onOpenSettings,
                onToggleHorizontalFlip: onToggleHorizontalFlip,
                onToggleVerticalFlip: onToggleVerticalFlip,
                flipHorizontal: flipHorizontal,
                flipVertical: flipVertical,
              ),
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

class _PlayerMorePanelHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _PlayerMorePanelHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            icon: const Icon(Icons.close_rounded, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
