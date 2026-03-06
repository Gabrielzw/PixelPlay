import 'package:flutter/material.dart';

import '../../../settings/domain/app_settings.dart';
import '../../domain/player_queue_item.dart';
import 'player_ui_constants.dart';

const double _kPreviewWidth = 1280;

class PlayerSurface extends StatelessWidget {
  final PlayerQueueItem item;
  final PlayerAspectRatio aspectRatioMode;
  final bool controlsVisible;

  const PlayerSurface({
    super.key,
    required this.item,
    required this.aspectRatioMode,
    required this.controlsVisible,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kPlayerBackground,
      child: ClipRect(
        child: SizedBox.expand(
          child: FittedBox(
            fit: _resolveBoxFit(aspectRatioMode),
            child: SizedBox(
              width: _kPreviewWidth,
              height: _kPreviewWidth / item.previewAspectRatio,
              child: _SurfacePreviewCard(item: item, dimmed: controlsVisible),
            ),
          ),
        ),
      ),
    );
  }

  BoxFit _resolveBoxFit(PlayerAspectRatio value) {
    return switch (value) {
      PlayerAspectRatio.fit => BoxFit.contain,
      PlayerAspectRatio.fill => BoxFit.fill,
      PlayerAspectRatio.original => BoxFit.none,
      PlayerAspectRatio.crop => BoxFit.cover,
    };
  }
}

class _SurfacePreviewCard extends StatelessWidget {
  final PlayerQueueItem item;
  final bool dimmed;

  const _SurfacePreviewCard({required this.item, required this.dimmed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dimOpacity = dimmed ? 0.24 : 0.12;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            applyOpacity(colorScheme.primary, 0.28),
            applyOpacity(colorScheme.secondary, 0.12),
            Colors.black,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.92,
                  colors: <Color>[
                    Colors.transparent,
                    applyOpacity(Colors.black, dimOpacity),
                    applyOpacity(Colors.black, 0.58),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  item.isRemote
                      ? Icons.cloud_circle_rounded
                      : Icons.movie_rounded,
                  size: 104,
                  color: applyOpacity(Colors.white, 0.92),
                ),
                const SizedBox(height: 18),
                Text(
                  '媒体渲染层待接入 media_kit',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '当前已实现播放器页面布局、手势层、控制面板与状态反馈。',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Positioned(
            left: 28,
            bottom: 28,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _InfoChip(label: item.isRemote ? 'WebDAV' : '本地'),
                _InfoChip(label: item.sourceLabel),
                if (item.resolutionText != null)
                  _InfoChip(label: item.resolutionText!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: applyOpacity(Colors.black, 0.36),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
