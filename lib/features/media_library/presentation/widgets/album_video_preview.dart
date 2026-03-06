import 'package:flutter/material.dart';

const double kVideoTilePreviewWidth = 120,
    kVideoTilePreviewAspectRatio = 1.42,
    kVideoTilePreviewInnerPadding = 8,
    kVideoTilePreviewGap = 6,
    kDurationBadgeOpacity = 0.72,
    kDurationBadgeRadius = 10,
    kDurationBadgeHorizontalPadding = 10,
    kDurationBadgeVerticalPadding = 4,
    kPreviewPaneRadius = 12,
    kPreviewTextBarRadius = 99,
    kPreviewTextBarHeightLarge = 8,
    kPreviewTextBarHeightSmall = 6,
    kPreviewTextBarWidthLarge = 40,
    kPreviewTextBarWidthMedium = 28,
    kPreviewTextBarWidthSmall = 18,
    kVideoPreviewRadius = 18,
    kPreviewHighlightOpacity = 0.35,
    kPreviewTextOpacity = 0.78,
    kGradientPrimaryOpacity = 0.95,
    kPreviewPaneMinContentWidth = 44,
    kPreviewPaneMinContentHeight = 30,
    kPosterPreviewMinHeight = 72;
const double kDurationBadgeFontSize = 12;
const double kDurationBadgeLineHeight = 1;

const Color kLightPreviewLavender = Color(0xFFDCD4FF),
    kLightPreviewRose = Color(0xFFFFD8E5),
    kLightPreviewSky = Color(0xFFD3EBFF),
    kLightPreviewWarm = Color(0xFFFFE7CC),
    kLightPreviewMint = Color(0xFFD7F5E8),
    kDarkPreviewLavender = Color(0xFF41365E),
    kDarkPreviewRose = Color(0xFF5A3946),
    kDarkPreviewSky = Color(0xFF28445B),
    kDarkPreviewWarm = Color(0xFF5B472D),
    kDarkPreviewMint = Color(0xFF25473C);

class AlbumVideoPreview extends StatelessWidget {
  final String durationText;
  final int previewSeed;

  const AlbumVideoPreview({
    super.key,
    required this.durationText,
    required this.previewSeed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kVideoTilePreviewWidth,
      child: AspectRatio(
        aspectRatio: kVideoTilePreviewAspectRatio,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(kVideoPreviewRadius),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: _PreviewLayout(previewSeed: previewSeed)),
              Positioned(
                right: kVideoTilePreviewInnerPadding,
                bottom: kVideoTilePreviewInnerPadding,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: kDurationBadgeOpacity,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(kDurationBadgeRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDurationBadgeHorizontalPadding,
                      vertical: kDurationBadgeVerticalPadding,
                    ),
                    child: Text(
                      durationText,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: kDurationBadgeFontSize,
                        fontWeight: FontWeight.w600,
                        height: kDurationBadgeLineHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewLayout extends StatelessWidget {
  final int previewSeed;

  const _PreviewLayout({required this.previewSeed});

  @override
  Widget build(BuildContext context) {
    final colors = _previewPalette(Theme.of(context).brightness);
    final variant = previewSeed % 3;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colors.first.withValues(alpha: kGradientPrimaryOpacity),
            colors.last,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kVideoTilePreviewInnerPadding),
        child: switch (variant) {
          0 => _PreviewStripVariant(colors: colors),
          1 => _PreviewStackVariant(colors: colors),
          _ => _PreviewPosterVariant(colors: colors),
        },
      ),
    );
  }
}

class _PreviewStripVariant extends StatelessWidget {
  final List<Color> colors;
  const _PreviewStripVariant({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(child: _PreviewPane(color: colors[1])),
              const SizedBox(height: kVideoTilePreviewGap),
              Expanded(child: _PreviewPane(color: colors[2])),
              const SizedBox(height: kVideoTilePreviewGap),
              Expanded(child: _PreviewPane(color: colors[3])),
            ],
          ),
        ),
        const SizedBox(width: kVideoTilePreviewGap),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(flex: 2, child: _PreviewPane(color: colors[4])),
              const SizedBox(height: kVideoTilePreviewGap),
              Expanded(child: _PreviewPane(color: colors[0])),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewStackVariant extends StatelessWidget {
  final List<Color> colors;
  const _PreviewStackVariant({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 2, child: _PreviewPane(color: colors[1])),
        const SizedBox(height: kVideoTilePreviewGap),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(child: _PreviewPane(color: colors[2])),
              const SizedBox(width: kVideoTilePreviewGap),
              Expanded(child: _PreviewPane(color: colors[3])),
              const SizedBox(width: kVideoTilePreviewGap),
              Expanded(child: _PreviewPane(color: colors[4])),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewPosterVariant extends StatelessWidget {
  final List<Color> colors;
  const _PreviewPosterVariant({required this.colors});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors[2],
        borderRadius: const BorderRadius.all(
          Radius.circular(kPreviewPaneRadius),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight < kPosterPreviewMinHeight) {
            return const Padding(
              padding: EdgeInsets.all(kVideoTilePreviewInnerPadding),
              child: Align(
                alignment: Alignment.topLeft,
                child: _PreviewTextBar(width: kPreviewTextBarWidthMedium),
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(kVideoTilePreviewInnerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _PreviewTextBar(width: kPreviewTextBarWidthLarge),
                SizedBox(height: 6),
                _PreviewTextBar(width: kPreviewTextBarWidthMedium),
                SizedBox(height: 6),
                _PreviewTextBar(width: kPreviewTextBarWidthSmall),
                Spacer(),
                _PreviewTextBar(width: kPreviewTextBarWidthMedium),
                SizedBox(height: 6),
                _PreviewTextBar(width: kPreviewTextBarWidthLarge),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PreviewPane extends StatelessWidget {
  final Color color;
  const _PreviewPane({required this.color});

  @override
  Widget build(BuildContext context) {
    final highlight = Colors.white.withValues(alpha: kPreviewHighlightOpacity);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(kPreviewPaneRadius),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[highlight, color],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < kPreviewPaneMinContentWidth ||
              constraints.maxHeight < kPreviewPaneMinContentHeight) {
            return const SizedBox.expand();
          }
          return const Padding(
            padding: EdgeInsets.all(kVideoTilePreviewInnerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _PreviewTextBar(width: kPreviewTextBarWidthMedium),
                Spacer(),
                _PreviewTextBar(
                  width: kPreviewTextBarWidthSmall,
                  height: kPreviewTextBarHeightSmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PreviewTextBar extends StatelessWidget {
  final double width;
  final double height;

  const _PreviewTextBar({
    required this.width,
    this.height = kPreviewTextBarHeightLarge,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: kPreviewTextOpacity),
        borderRadius: const BorderRadius.all(
          Radius.circular(kPreviewTextBarRadius),
        ),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}

List<Color> _previewPalette(Brightness brightness) {
  if (brightness == Brightness.dark) {
    return const <Color>[
      kDarkPreviewLavender,
      kDarkPreviewRose,
      kDarkPreviewSky,
      kDarkPreviewWarm,
      kDarkPreviewMint,
    ];
  }
  return const <Color>[
    kLightPreviewLavender,
    kLightPreviewRose,
    kLightPreviewSky,
    kLightPreviewWarm,
    kLightPreviewMint,
  ];
}
