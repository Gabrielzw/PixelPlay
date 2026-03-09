import '../domain/playlist_source_repository.dart';
import '../presentation/playlist_source_models.dart';

class InMemoryPlaylistSourceRepository implements PlaylistSourceRepository {
  final List<PlaylistSourceEntry> _entries;

  InMemoryPlaylistSourceRepository({List<PlaylistSourceEntry>? initialEntries})
    : _entries = List<PlaylistSourceEntry>.of(
        initialEntries ?? const <PlaylistSourceEntry>[],
      );

  @override
  List<PlaylistSourceEntry> loadEntries() {
    return List<PlaylistSourceEntry>.unmodifiable(_entries);
  }

  @override
  PlaylistSourceEntry saveEntry(PlaylistSourceEntry entry) {
    final entryIndex = _entries.indexWhere(
      (PlaylistSourceEntry item) => item.id == entry.id,
    );
    if (entryIndex >= 0) {
      _entries[entryIndex] = entry;
      return entry;
    }

    _entries.add(entry);
    return entry;
  }

  @override
  void deleteEntries(Set<String> entryIds) {
    if (entryIds.isEmpty) {
      return;
    }

    _entries.removeWhere(
      (PlaylistSourceEntry entry) => entryIds.contains(entry.id),
    );
  }
}
