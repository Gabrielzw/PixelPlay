import '../presentation/playlist_source_models.dart';

abstract interface class PlaylistSourceRepository {
  List<PlaylistSourceEntry> loadEntries();

  PlaylistSourceEntry saveEntry(PlaylistSourceEntry entry);

  void deleteEntries(Set<String> entryIds);
}
