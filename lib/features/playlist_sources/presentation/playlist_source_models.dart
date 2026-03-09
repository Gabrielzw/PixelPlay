import 'package:flutter/foundation.dart';

import '../../media_library/domain/entities/local_album.dart';
import '../../webdav_client/domain/webdav_paths.dart';
import '../../webdav_client/domain/webdav_server_config.dart';

const String kPlaylistRootDirectoryLabel = '根目录';
const String kPlaylistUnnamedAlbumLabel = '未命名相册';

enum PlaylistSourceKind { localAlbum, webDavDirectory }

@immutable
class PlaylistSourceEntry {
  final String id;
  final String title;
  final DateTime createdAt;
  final PlaylistSourceKind sourceKind;
  final String? localAlbumBucketId;
  final String? localAlbumName;
  final int? localAlbumVideoCount;
  final int? localAlbumLatestDateAddedSeconds;
  final int? localAlbumLatestVideoId;
  final String? localAlbumLatestVideoPath;
  final int? localAlbumLatestVideoDateModified;
  final String? webDavAccountId;
  final String? webDavAccountAlias;
  final String? webDavDirectoryPath;

  const PlaylistSourceEntry({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.sourceKind,
    this.localAlbumBucketId,
    this.localAlbumName,
    this.localAlbumVideoCount,
    this.localAlbumLatestDateAddedSeconds,
    this.localAlbumLatestVideoId,
    this.localAlbumLatestVideoPath,
    this.localAlbumLatestVideoDateModified,
    this.webDavAccountId,
    this.webDavAccountAlias,
    this.webDavDirectoryPath,
  });

  factory PlaylistSourceEntry.localAlbum({
    required LocalAlbum album,
    required DateTime createdAt,
  }) {
    return PlaylistSourceEntry(
      id: 'playlist-source-${createdAt.microsecondsSinceEpoch}',
      title: resolvePlaylistAlbumTitle(album.bucketName),
      createdAt: createdAt,
      sourceKind: PlaylistSourceKind.localAlbum,
      localAlbumBucketId: album.bucketId,
      localAlbumName: album.bucketName,
      localAlbumVideoCount: album.videoCount,
      localAlbumLatestDateAddedSeconds: album.latestDateAddedSeconds,
      localAlbumLatestVideoId: album.latestVideoId,
      localAlbumLatestVideoPath: album.latestVideoPath,
      localAlbumLatestVideoDateModified: album.latestVideoDateModified,
    );
  }

  factory PlaylistSourceEntry.webDavDirectory({
    required WebDavServerConfig account,
    required String path,
    required DateTime createdAt,
  }) {
    final normalizedPath = normalizeWebDavPath(path);
    return PlaylistSourceEntry(
      id: 'playlist-source-${createdAt.microsecondsSinceEpoch}',
      title: resolvePlaylistWebDavTitle(normalizedPath),
      createdAt: createdAt,
      sourceKind: PlaylistSourceKind.webDavDirectory,
      webDavAccountId: account.id,
      webDavAccountAlias: account.alias,
      webDavDirectoryPath: normalizedPath,
    );
  }

  String get sourceKey {
    return switch (sourceKind) {
      PlaylistSourceKind.localAlbum => 'local:$localAlbumBucketId',
      PlaylistSourceKind.webDavDirectory =>
        'webdav:$webDavAccountId:${normalizeWebDavPath(webDavDirectoryPath ?? kWebDavRootPath)}',
    };
  }

  String get subtitle {
    return switch (sourceKind) {
      PlaylistSourceKind.localAlbum =>
        '本地相册 · ${localAlbumVideoCount ?? 0} 个视频',
      PlaylistSourceKind.webDavDirectory =>
        'WebDAV · ${webDavAccountAlias ?? '未知账户'}',
    };
  }

  String? get detailText {
    return switch (sourceKind) {
      PlaylistSourceKind.localAlbum => localAlbumBucketId,
      PlaylistSourceKind.webDavDirectory => webDavDirectoryPath,
    };
  }

  LocalAlbum toLocalAlbum() {
    if (sourceKind != PlaylistSourceKind.localAlbum ||
        localAlbumBucketId == null ||
        localAlbumName == null ||
        localAlbumVideoCount == null ||
        localAlbumLatestDateAddedSeconds == null ||
        localAlbumLatestVideoId == null ||
        localAlbumLatestVideoPath == null ||
        localAlbumLatestVideoDateModified == null) {
      throw StateError('播放列表中的本地相册信息不完整。');
    }

    return LocalAlbum(
      bucketId: localAlbumBucketId!,
      bucketName: localAlbumName!,
      videoCount: localAlbumVideoCount!,
      latestDateAddedSeconds: localAlbumLatestDateAddedSeconds!,
      latestVideoId: localAlbumLatestVideoId!,
      latestVideoPath: localAlbumLatestVideoPath!,
      latestVideoDateModified: localAlbumLatestVideoDateModified!,
    );
  }
}

List<PlaylistSourceEntry> sortPlaylistSources(
  Iterable<PlaylistSourceEntry> entries,
) {
  final nextEntries = entries.toList(growable: false);
  nextEntries.sort(
    (PlaylistSourceEntry left, PlaylistSourceEntry right) =>
        right.createdAt.compareTo(left.createdAt),
  );
  return List<PlaylistSourceEntry>.unmodifiable(nextEntries);
}

bool playlistSourcesReferToSameTarget(
  PlaylistSourceEntry left,
  PlaylistSourceEntry right,
) {
  return left.sourceKey == right.sourceKey;
}

String resolvePlaylistAlbumTitle(String bucketName) {
  final title = bucketName.trim();
  if (title.isEmpty) {
    return kPlaylistUnnamedAlbumLabel;
  }
  return title;
}

String resolvePlaylistWebDavTitle(String path) {
  final normalizedPath = normalizeWebDavPath(path);
  if (normalizedPath == kWebDavRootPath) {
    return kPlaylistRootDirectoryLabel;
  }

  final segments = normalizedPath
      .split('/')
      .where((String segment) => segment.isNotEmpty)
      .toList(growable: false);
  if (segments.isEmpty) {
    return kPlaylistRootDirectoryLabel;
  }
  return segments.last;
}
