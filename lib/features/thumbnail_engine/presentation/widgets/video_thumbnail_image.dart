import 'dart:async';
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
  Future<String>? _thumbnailFuture;
  String? _thumbnailPath;
  Object? _thumbnailError;
  bool _animateFirstFrame = true;

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
    final cachedPath = _thumbnailQueue.cachedPath(widget.request.cacheKey);
    _thumbnailFuture = null;
    _thumbnailPath = cachedPath;
    _thumbnailError = null;
    _animateFirstFrame = cachedPath == null;
    if (cachedPath != null) {
      return;
    }

    final future = _thumbnailQueue.enqueue(
      widget.request,
      priority: widget.priority,
    );
    _thumbnailFuture = future;
    unawaited(
      future.then<void>(
        (String path) => _completeThumbnail(future: future, path: path),
        onError: (Object error, _) {
          _failThumbnail(future: future, error: error);
        },
      ),
    );
  }

  void _completeThumbnail({
    required Future<String> future,
    required String path,
  }) {
    if (!mounted || !identical(_thumbnailFuture, future)) {
      return;
    }
    setState(() {
      _thumbnailFuture = null;
      _thumbnailPath = path;
      _thumbnailError = null;
      _animateFirstFrame = true;
    });
  }

  void _failThumbnail({required Future<String> future, required Object error}) {
    if (!mounted || !identical(_thumbnailFuture, future)) {
      return;
    }
    setState(() {
      _thumbnailFuture = null;
      _thumbnailError = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailPath = _thumbnailPath;
    if (thumbnailPath != null) {
      return _buildThumbnail(thumbnailPath);
    }
    if (_thumbnailError != null) {
      return _buildErrorPlaceholder();
    }
    return widget.placeholder;
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
          frameBuilder: _buildThumbnailFrame,
          errorBuilder: (_, _, _) => _buildErrorPlaceholder(),
        ),
      ],
    );
  }

  Widget _buildThumbnailFrame(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (!_animateFirstFrame) {
      return child;
    }
    final isVisible = wasSynchronouslyLoaded || frame != null;
    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: kThumbnailFadeDuration,
      curve: kThumbnailFadeCurve,
      child: child,
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
