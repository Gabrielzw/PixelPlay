import 'package:isar_community/isar.dart';

import '../../../shared/data/isar/schemas/watch_history_isar_model.dart';
import '../domain/watch_history_repository.dart';

class IsarWatchHistoryRepository implements WatchHistoryRepository {
  final Isar isar;

  const IsarWatchHistoryRepository({required this.isar});

  @override
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.watchHistoryIsarModels.clear();
    });
  }

  @override
  Future<WatchHistoryRecord?> load(String mediaId) async {
    final record = await _findRecord(mediaId);
    return record?.toDomain();
  }

  @override
  Future<List<WatchHistoryRecord>> loadAll() async {
    final records = await isar.watchHistoryIsarModels.where().findAll();
    records.sort(
      (WatchHistoryIsarModel left, WatchHistoryIsarModel right) =>
          right.watchedAtMs.compareTo(left.watchedAtMs),
    );
    return List<WatchHistoryRecord>.unmodifiable(
      records.map((WatchHistoryIsarModel record) => record.toDomain()),
    );
  }

  @override
  Future<void> removeAll(Iterable<String> mediaIds) async {
    final targetIds = mediaIds.toSet();
    if (targetIds.isEmpty) {
      return;
    }

    final storedRecords = await isar.watchHistoryIsarModels.where().findAll();
    final databaseIds = storedRecords
        .where(
          (WatchHistoryIsarModel record) => targetIds.contains(record.mediaId),
        )
        .map((WatchHistoryIsarModel record) => record.id)
        .toList(growable: false);
    if (databaseIds.isEmpty) {
      return;
    }

    await isar.writeTxn(() async {
      await isar.watchHistoryIsarModels.deleteAll(databaseIds);
    });
  }

  @override
  Future<void> save(WatchHistoryRecord record) async {
    final storedRecord = await _findRecord(record.mediaId);
    final nextRecord = WatchHistoryIsarModel.fromDomain(
      record,
      id: storedRecord?.id,
    );
    await isar.writeTxn(() async {
      await isar.watchHistoryIsarModels.put(nextRecord);
    });
  }

  Future<WatchHistoryIsarModel?> _findRecord(String mediaId) {
    return isar.watchHistoryIsarModels
        .filter()
        .mediaIdEqualTo(mediaId)
        .findFirst();
  }
}
