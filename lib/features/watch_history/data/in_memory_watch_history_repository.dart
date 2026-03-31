import '../domain/watch_history_repository.dart';

class InMemoryWatchHistoryRepository implements WatchHistoryRepository {
  final Map<String, WatchHistoryRecord> _records;

  InMemoryWatchHistoryRepository({
    Map<String, WatchHistoryRecord> initialRecords =
        const <String, WatchHistoryRecord>{},
  }) : _records = Map<String, WatchHistoryRecord>.from(initialRecords);

  @override
  Future<void> clearAll() async {
    _records.clear();
  }

  @override
  Future<WatchHistoryRecord?> load(String mediaId) async {
    return _records[mediaId];
  }

  @override
  Future<List<WatchHistoryRecord>> loadAll() async {
    final records = _records.values.toList(growable: false);
    records.sort(
      (WatchHistoryRecord left, WatchHistoryRecord right) =>
          right.watchedAtMs.compareTo(left.watchedAtMs),
    );
    return List<WatchHistoryRecord>.unmodifiable(records);
  }

  @override
  Future<void> removeAll(Iterable<String> mediaIds) async {
    for (final mediaId in mediaIds) {
      _records.remove(mediaId);
    }
  }

  @override
  Future<void> save(WatchHistoryRecord record) async {
    _records[record.mediaId] = record;
  }
}
