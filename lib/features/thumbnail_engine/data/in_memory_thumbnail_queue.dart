import 'dart:convert';
import 'dart:io';

import '../domain/thumbnail_queue.dart';
import '../domain/video_thumbnail_request.dart';

const String kTestThumbnailBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+p3tQAAAAASUVORK5CYII=';

class InMemoryThumbnailQueue implements ThumbnailQueue {
  String? _thumbnailPath;
  Directory? _thumbnailDirectory;

  @override
  Future<String> enqueue(
    VideoThumbnailRequest request, {
    int priority = 0,
  }) async {
    if (_thumbnailPath != null) {
      return _thumbnailPath!;
    }

    final directory = await Directory.systemTemp.createTemp('pixelplay_thumb_');
    final file = File(
      '${directory.path}${Platform.pathSeparator}thumbnail.png',
    );
    await file.writeAsBytes(base64Decode(kTestThumbnailBase64), flush: true);
    _thumbnailDirectory = directory;
    _thumbnailPath = file.path;
    return file.path;
  }

  @override
  void cancel(String cacheKey) {}

  @override
  Future<void> clearCache() async {
    _thumbnailPath = null;
    await _thumbnailDirectory?.delete(recursive: true);
    _thumbnailDirectory = null;
  }
}
