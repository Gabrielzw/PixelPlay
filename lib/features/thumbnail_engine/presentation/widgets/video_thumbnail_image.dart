import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/thumbnail_queue.dart';
import '../../domain/video_thumbnail_request.dart';

const Duration kThumbnailFadeDuration = Duration(milliseconds: 220);
const Curve kThumbnailFadeCurve = Curves.easeOutCubic;

class VideoThumbnailImage extends StatefulWidget {
  final VideoThumbnailRequest request;
  final Widget placeholder;
  final Widget? errorPlaceholder;
  final BoxFit fit;
  final int priority;

  const VideoThumbnailImage({
    super.key,
    required this.request,
    required this.placeholder,
    this.errorPlaceholder,
    this.fit = BoxFit.cover,
    this.priority = 0,
  });

  @override
  State<VideoThumbnailImage> createState() => _VideoThumbnailImageState();
}

class _VideoThumbnailImageState extends State<VideoThumbnailImage> {
  late final ThumbnailQueue _thumbnailQueue;
  late Future<String> _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailQueue = Get.find<ThumbnailQueue>();
    _bindThumbnailFuture();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnailImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request.cacheKey == widget.request.cacheKey) {
      return;
    }
    _thumbnailQueue.cancel(oldWidget.request.cacheKey);
    _bindThumbnailFuture();
  }

  @override
  void dispose() {
    _thumbnailQueue.cancel(widget.request.cacheKey);
    super.dispose();
  }

  void _bindThumbnailFuture() {
    _thumbnailFuture = _thumbnailQueue.enqueue(
      widget.request,
      priority: widget.priority,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _thumbnailFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return _buildThumbnail(snapshot.requireData);
        }
        if (snapshot.hasError) {
          return _buildErrorPlaceholder();
        }
        return widget.placeholder;
      },
    );
  }

  Widget _buildThumbnail(String path) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        widget.placeholder,
        Image.file(
          File(path),
          fit: widget.fit,
          filterQuality: FilterQuality.low,
          gaplessPlayback: true,
          frameBuilder: (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            final isVisible = wasSynchronouslyLoaded || frame != null;
            return AnimatedOpacity(
              opacity: isVisible ? 1 : 0,
              duration: kThumbnailFadeDuration,
              curve: kThumbnailFadeCurve,
              child: child,
            );
          },
          errorBuilder: (_, _, _) => _buildErrorPlaceholder(),
        ),
      ],
    );
  }

  Widget _buildErrorPlaceholder() {
    final fallback = widget.errorPlaceholder ?? widget.placeholder;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        fallback,
        const Center(
          child: Icon(
            Icons.broken_image_rounded,
            color: Colors.white70,
            size: 20,
          ),
        ),
      ],
    );
  }
}
