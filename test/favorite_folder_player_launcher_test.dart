import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/favorites/presentation/favorite_folder_player_launcher.dart';
import 'package:pixelplay/features/favorites/presentation/favorite_models.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/video_thumbnail_request.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_account_repository.dart';
import 'package:pixelplay/features/webdav_client/domain/webdav_server_config.dart';
import 'package:pixelplay/shared/domain/media_source_kind.dart';

void main() {
  test('builds folder playlist from stored local favorite videos', () async {
    final session = await buildFavoriteFolderPlaybackSession(
      folder: FavoriteFolderEntry(
        id: 'travel-folder',
        title: '旅行收藏',
        createdAt: DateTime(2026, 3, 9, 8),
        videos: <FavoriteVideoEntry>[
          FavoriteVideoEntry(
            id: 'video-1',
            title: '旅行Vlog.mp4',
            durationText: '12:40',
            updatedAt: DateTime(2026, 3, 9, 9),
            previewSeed: 1,
            thumbnailRequest: VideoThumbnailRequest.tile(
              videoId: 11,
              videoPath: '/storage/emulated/0/DCIM/旅行Vlog.mp4',
              dateModified: 111,
            ),
          ),
          FavoriteVideoEntry(
            id: 'video-2',
            title: '海边日落.mp4',
            durationText: '08:16',
            updatedAt: DateTime(2026, 3, 9, 10),
            previewSeed: 2,
            path: '/storage/emulated/0/DCIM/海边日落.mp4',
            sourceLabel: 'Camera',
            durationMs: 496000,
            sourceKind: MediaSourceKind.local,
            localVideoId: 22,
            localVideoDateModified: 222,
          ),
        ],
      ),
      initialVideoId: 'video-2',
      webDavAccountRepository: InMemoryWebDavAccountRepository(),
    );

    expect(session.playlist, hasLength(2));
    expect(session.initialIndex, 1);
    expect(session.playlist.first.path, '/storage/emulated/0/DCIM/旅行Vlog.mp4');
    expect(session.playlist.first.localVideoId, 11);
    expect(session.playlist.first.sourceKind, MediaSourceKind.local);
    expect(session.playlist[1].id, 'video-2');
  });

  test('restores webdav headers when building folder playlist', () async {
    final repository = InMemoryWebDavAccountRepository();
    final account = WebDavServerConfig(
      id: 'webdav-1',
      alias: 'NAS',
      url: Uri.parse('https://dav.example.com'),
      username: 'demo',
      rootPath: '/',
    );
    await repository.saveAccount(account, password: 'secret');

    final session = await buildFavoriteFolderPlaybackSession(
      folder: FavoriteFolderEntry(
        id: 'remote-folder',
        title: '远程收藏',
        createdAt: DateTime(2026, 3, 9, 8),
        videos: <FavoriteVideoEntry>[
          FavoriteVideoEntry(
            id: '/movies/demo.mp4',
            title: 'Demo.mp4',
            durationText: '03:25',
            updatedAt: DateTime(2026, 3, 9, 9),
            previewSeed: 3,
            sourceLabel: 'NAS /movies',
            path: '/movies/demo.mp4',
            sourceUri: 'https://dav.example.com/movies/demo.mp4',
            durationMs: 205000,
            sourceKind: MediaSourceKind.webDav,
            webDavAccountId: 'webdav-1',
          ),
        ],
      ),
      initialVideoId: '/movies/demo.mp4',
      webDavAccountRepository: repository,
    );

    expect(session.playlist.single.sourceKind, MediaSourceKind.webDav);
    expect(
      session.playlist.single.httpHeaders['Authorization'],
      'Basic ${base64Encode(utf8.encode('demo:secret'))}',
    );
  });
}
