import 'package:get/get.dart';

import '../../../media_library/domain/entities/local_album.dart';
import '../../../webdav_client/domain/webdav_paths.dart';
import '../../../webdav_client/domain/webdav_server_config.dart';
import '../../domain/playlist_source_repository.dart';
import '../playlist_source_models.dart';

class PlaylistSourcesController extends GetxController {
  final PlaylistSourceRepository repository;
  final RxList<PlaylistSourceEntry> entries = <PlaylistSourceEntry>[].obs;

  PlaylistSourcesController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    refreshEntries();
  }

  void refreshEntries() {
    entries.assignAll(sortPlaylistSources(repository.loadEntries()));
  }

  PlaylistSourceEntry createLocalAlbumEntry({
    required LocalAlbum album,
    DateTime? now,
  }) {
    final entry = PlaylistSourceEntry.localAlbum(
      album: album,
      createdAt: now ?? DateTime.now(),
    );
    return _saveUniqueEntry(entry);
  }

  PlaylistSourceEntry createWebDavDirectoryEntry({
    required WebDavServerConfig account,
    required String path,
    DateTime? now,
  }) {
    final entry = PlaylistSourceEntry.webDavDirectory(
      account: account,
      path: normalizeWebDavPath(path),
      createdAt: now ?? DateTime.now(),
    );
    return _saveUniqueEntry(entry);
  }

  void deleteEntries(Set<String> entryIds) {
    if (entryIds.isEmpty) {
      return;
    }

    repository.deleteEntries(entryIds);
    refreshEntries();
  }

  PlaylistSourceEntry _saveUniqueEntry(PlaylistSourceEntry entry) {
    _assertSourceDoesNotExist(entry);
    final savedEntry = repository.saveEntry(entry);
    refreshEntries();
    return savedEntry;
  }

  void _assertSourceDoesNotExist(PlaylistSourceEntry entry) {
    final duplicatedEntry = entries.firstWhereOrNull(
      (PlaylistSourceEntry item) =>
          playlistSourcesReferToSameTarget(item, entry),
    );
    if (duplicatedEntry == null) {
      return;
    }

    throw StateError('该播放列表已存在，无需重复添加。');
  }
}
