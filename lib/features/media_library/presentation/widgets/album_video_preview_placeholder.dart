import 'package:flutter/material.dart';

import 'album_video_preview_tokens.dart';

class AlbumVideoPreviewPlaceholder extends StatelessWidget {
  final int previewSeed;

  const AlbumVideoPreviewPlaceholder({super.key, required this.previewSeed});

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
