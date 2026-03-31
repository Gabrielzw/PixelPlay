import 'package:isar_community/isar.dart';

import '../../../shared/data/isar/schemas/playlist_source_isar_model.dart';
import '../domain/playlist_source_repository.dart';
import '../presentation/playlist_source_models.dart';

class IsarPlaylistSourceRepository implements PlaylistSourceRepository {
  final Isar isar;

  const IsarPlaylistSourceRepository({required this.isar});

  @override
  List<PlaylistSourceEntry> loadEntries() {
    return List<PlaylistSourceEntry>.unmodifiable(
      isar.playlistSourceIsarModels.where().findAllSync().map(
        (PlaylistSourceIsarModel entry) => entry.toDomain(),
      ),
    );
  }

  @override
  PlaylistSourceEntry saveEntry(PlaylistSourceEntry entry) {
    isar.writeTxnSync(() {
      isar.playlistSourceIsarModels.putSync(
        PlaylistSourceIsarModel.fromDomain(entry),
      );
    });
    return entry;
  }

  @override
  void deleteEntries(Set<String> entryIds) {
    if (entryIds.isEmpty) {
      return;
    }

    isar.writeTxnSync(() {
      final entries = _findEntriesByIds(entryIds);
      for (final entry in entries) {
        isar.playlistSourceIsarModels.deleteSync(entry.id);
      }
    });
  }

  List<PlaylistSourceIsarModel> _findEntriesByIds(Set<String> entryIds) {
    return isar.playlistSourceIsarModels
        .where()
        .findAllSync()
        .where(
          (PlaylistSourceIsarModel entry) => entryIds.contains(entry.entryId),
        )
        .toList(growable: false);
  }
}
