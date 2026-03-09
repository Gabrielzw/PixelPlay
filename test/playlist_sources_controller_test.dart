import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/media_library/domain/entities/local_album.dart';
import 'package:pixelplay/features/playlist_sources/data/in_memory_playlist_source_repository.dart';
import 'package:pixelplay/features/playlist_sources/presentation/controllers/playlist_sources_controller.dart';
import 'package:pixelplay/features/webdav_client/domain/webdav_server_config.dart';

void main() {
  test('creates local album playlist and sorts by newest first', () {
    final controller = PlaylistSourcesController(
      repository: InMemoryPlaylistSourceRepository(),
    );

    controller.createLocalAlbumEntry(
      album: _buildAlbum(bucketId: 'album-1', bucketName: '旅行'),
      now: DateTime(2026, 3, 9, 10),
    );
    controller.createLocalAlbumEntry(
      album: _buildAlbum(bucketId: 'album-2', bucketName: '电影'),
      now: DateTime(2026, 3, 9, 11),
    );

    expect(controller.entries.map((entry) => entry.title), <String>[
      '电影',
      '旅行',
    ]);
  });

  test('rejects duplicate playlist source targets', () {
    final controller = PlaylistSourcesController(
      repository: InMemoryPlaylistSourceRepository(),
    );
    final account = WebDavServerConfig(
      id: 'webdav-1',
      alias: '家庭云盘',
      url: Uri.parse('https://example.com/dav/'),
      username: 'tester',
      rootPath: '/',
    );

    controller.createWebDavDirectoryEntry(
      account: account,
      path: '/剧集',
      now: DateTime(2026, 3, 9, 12),
    );

    expect(
      () => controller.createWebDavDirectoryEntry(
        account: account,
        path: '/剧集',
        now: DateTime(2026, 3, 9, 13),
      ),
      throwsStateError,
    );
  });
}

LocalAlbum _buildAlbum({required String bucketId, required String bucketName}) {
  return LocalAlbum(
    bucketId: bucketId,
    bucketName: bucketName,
    videoCount: 3,
    latestDateAddedSeconds: 123,
    latestVideoId: 456,
    latestVideoPath: '/storage/$bucketId.mp4',
    latestVideoDateModified: 789,
  );
}
