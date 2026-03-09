import 'dart:async';
import 'dart:io';

import '../domain/thumbnail_queue.dart';
import '../domain/thumbnail_store.dart';
import '../domain/video_thumbnail_request.dart';

const int kMinThumbnailConcurrency = 1;
const int kThumbnailConcurrencyHeadroom = 1;

class QueuedThumbnailQueue implements ThumbnailQueue {
  final ThumbnailStore store;
  final int maxConcurrent;
  final Map<String, String> _resolvedPaths = <String, String>{};
  final Map<String, _ThumbnailTaskEntry> _entriesByKey =
      <String, _ThumbnailTaskEntry>{};
  final List<_ThumbnailTaskEntry> _pendingEntries = <_ThumbnailTaskEntry>[];
  int _activeCount = 0;
  int _sequence = 0;

  QueuedThumbnailQueue({required this.store, int? maxConcurrent})
    : maxConcurrent = _resolveMaxConcurrent(maxConcurrent);

  @override
  Future<String> enqueue(VideoThumbnailRequest request, {int priority = 0}) {
    final cachedPath = _resolvedPaths[request.cacheKey];
    if (cachedPath != null) {
      return Future<String>.value(cachedPath);
    }

    final existingEntry = _entriesByKey[request.cacheKey];
    if (existingEntry != null) {
      if (priority > existingEntry.priority) {
        existingEntry.priority = priority;
      }
      return existingEntry.completer.future;
    }

    final entry = _ThumbnailTaskEntry(
      request: request,
      completer: Completer<String>(),
      priority: priority,
      order: _sequence,
    );
    _sequence += 1;
    _entriesByKey[request.cacheKey] = entry;
    _pendingEntries.add(entry);
    _schedulePendingTasks();
    return entry.completer.future;
  }

  @override
  void cancel(String cacheKey) {
    final entry = _entriesByKey[cacheKey];
    if (entry == null) {
      return;
    }
    if (entry.isRunning) {
      entry.isCancelled = true;
      return;
    }

    _pendingEntries.remove(entry);
    _entriesByKey.remove(cacheKey);
    if (!entry.completer.isCompleted) {
      entry.completer.completeError(const ThumbnailCancelledException());
    }
  }

  @override
  Future<void> clearCache() async {
    _cancelPendingEntries();
    _cancelRunningEntries();
    _resolvedPaths.clear();
    await store.clearCache();
  }

  void _schedulePendingTasks() {
    while (_activeCount < maxConcurrent) {
      final entry = _takeNextPendingEntry();
      if (entry == null) {
        return;
      }
      _runEntry(entry);
    }
  }

  _ThumbnailTaskEntry? _takeNextPendingEntry() {
    if (_pendingEntries.isEmpty) {
      return null;
    }

    var bestIndex = 0;
    for (var index = 1; index < _pendingEntries.length; index += 1) {
      if (_shouldPromote(_pendingEntries[index], _pendingEntries[bestIndex])) {
        bestIndex = index;
      }
    }

    final entry = _pendingEntries.removeAt(bestIndex);
    entry.isRunning = true;
    return entry;
  }

  bool _shouldPromote(
    _ThumbnailTaskEntry candidate,
    _ThumbnailTaskEntry current,
  ) {
    if (candidate.priority != current.priority) {
      return candidate.priority > current.priority;
    }
    return candidate.order < current.order;
  }

  void _runEntry(_ThumbnailTaskEntry entry) {
    _activeCount += 1;
    _executeEntry(entry);
  }

  Future<void> _executeEntry(_ThumbnailTaskEntry entry) async {
    try {
      final path = await store.resolveThumbnail(entry.request);
      if (entry.isCancelled) {
        _completeCancelledEntry(entry);
        return;
      }
      _resolvedPaths[entry.request.cacheKey] = path;
      _completeEntry(entry, path);
    } catch (error, stackTrace) {
      _failEntry(entry, error, stackTrace);
    } finally {
      _entriesByKey.remove(entry.request.cacheKey);
      _activeCount -= 1;
      _schedulePendingTasks();
    }
  }

  void _completeEntry(_ThumbnailTaskEntry entry, String path) {
    if (entry.completer.isCompleted) {
      return;
    }
    entry.completer.complete(path);
  }

  void _completeCancelledEntry(_ThumbnailTaskEntry entry) {
    if (entry.completer.isCompleted) {
      return;
    }
    entry.completer.completeError(const ThumbnailCancelledException());
  }

  void _failEntry(
    _ThumbnailTaskEntry entry,
    Object error,
    StackTrace stackTrace,
  ) {
    if (entry.completer.isCompleted) {
      return;
    }
    entry.completer.completeError(error, stackTrace);
  }

  void _cancelPendingEntries() {
    if (_pendingEntries.isEmpty) {
      return;
    }

    final pendingEntries = List<_ThumbnailTaskEntry>.from(_pendingEntries);
    _pendingEntries.clear();
    for (final entry in pendingEntries) {
      _entriesByKey.remove(entry.request.cacheKey);
      _completeCancelledEntry(entry);
    }
  }

  void _cancelRunningEntries() {
    for (final entry in _entriesByKey.values) {
      if (!entry.isRunning) {
        continue;
      }
      entry.isCancelled = true;
    }
  }
}

int _resolveMaxConcurrent(int? requestedConcurrency) {
  if (requestedConcurrency != null && requestedConcurrency > 0) {
    return requestedConcurrency;
  }
  final fallback = Platform.numberOfProcessors - kThumbnailConcurrencyHeadroom;
  return fallback < kMinThumbnailConcurrency
      ? kMinThumbnailConcurrency
      : fallback;
}

class ThumbnailCancelledException implements Exception {
  const ThumbnailCancelledException();

  @override
  String toString() => 'Thumbnail request cancelled.';
}

class _ThumbnailTaskEntry {
  final VideoThumbnailRequest request;
  final Completer<String> completer;
  final int order;
  int priority;
  bool isRunning;
  bool isCancelled;

  _ThumbnailTaskEntry({
    required this.request,
    required this.completer,
    required this.priority,
    required this.order,
  }) : isRunning = false,
       isCancelled = false;
}
