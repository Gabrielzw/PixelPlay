abstract interface class ThumbnailQueue {
  Future<String> enqueue(String videoPath, {int priority = 0});
  void cancel(String videoPath);
  Future<void> clearCache();
}

