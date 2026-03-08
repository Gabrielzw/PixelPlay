import 'package:flutter/material.dart';

import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../../thumbnail_engine/presentation/widgets/video_thumbnail_image.dart';

const double kLibraryAlbumCardRadius = 24;
const double kLibraryAlbumCoverAspectRatio = 1.56;
const double kLibraryAlbumShadowBlur = 18;
const double kLibraryAlbumShadowOffsetY = 10;
const double kLibraryAlbumShadowOpacity = 0.08;
const double kLibraryAlbumOverlayOpacity = 0.14;
const double kLibraryAlbumShapeOpacity = 0.28;

@immutable
class LibraryAlbumPreview {
  final String title;
  final String subtitle;
  final Color startColor;
  final Color endColor;
  final VideoThumbnailRequest? thumbnailRequest;

  const LibraryAlbumPreview({
    required this.title,
    required this.subtitle,
    required this.startColor,
    required this.endColor,
    this.thumbnailRequest,
  });
}

class LibraryAlbumCard extends StatelessWidget {
  final LibraryAlbumPreview album;
  final VoidCallback onTap;

  const LibraryAlbumCard({super.key, required this.album, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kLibraryAlbumCardRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: kLibraryAlbumShadowOpacity),
            blurRadius: kLibraryAlbumShadowBlur,
            offset: const Offset(0, kLibraryAlbumShadowOffsetY),
          ),
        ],
      ),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(kLibraryAlbumCardRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _LibraryAlbumCover(album: album),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: _LibraryAlbumMeta(album: album),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryAlbumMeta extends StatelessWidget {
  final LibraryAlbumPreview album;

  const _LibraryAlbumMeta({required this.album});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, height: 1.05);
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          album.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        const SizedBox(height: 4),
        Text(
          album.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: subtitleStyle,
        ),
      ],
    );
  }
}

class _LibraryAlbumCover extends StatelessWidget {
  final LibraryAlbumPreview album;

  const _LibraryAlbumCover({required this.album});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: kLibraryAlbumCoverAspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[album.startColor, album.endColor],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -28,
              right: -14,
              child: _GlowCircle(
                size: 104,
                color: Colors.white.withValues(
                  alpha: kLibraryAlbumShapeOpacity,
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -18,
              child: _GlowCircle(
                size: 96,
                color: Colors.black.withValues(
                  alpha: kLibraryAlbumOverlayOpacity,
                ),
              ),
            ),
            Positioned.fill(child: _AlbumCoverThumbnail(album: album)),
          ],
        ),
      ),
    );
  }
}

class _AlbumCoverThumbnail extends StatelessWidget {
  final LibraryAlbumPreview album;

  const _AlbumCoverThumbnail({required this.album});

  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = album.thumbnailRequest;
    if (thumbnailRequest == null) {
      return const _PreviewStack();
    }

    return VideoThumbnailImage(
      request: thumbnailRequest,
      fit: BoxFit.cover,
      priority: 1,
      placeholder: const _PreviewStack(),
    );
  }
}

class _PreviewStack extends StatelessWidget {
  const _PreviewStack();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Stack(
          children: <Widget>[
            _PreviewCard(offset: const Offset(0, 8), angle: -0.06),
            _PreviewCard(offset: const Offset(22, 18), angle: 0.04),
            _PreviewCard(offset: const Offset(44, 2), angle: 0.02),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final Offset offset;
  final double angle;

  const _PreviewCard({required this.offset, required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 70,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.54),
              border: Border.all(color: Colors.white.withValues(alpha: 0.42)),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 12,
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
