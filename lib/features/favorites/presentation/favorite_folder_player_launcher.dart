import 'dart:async';
import 'package:flutter/material.dart';

import '../../../shared/domain/media_source_kind.dart';
import '../../../shared/utils/not_implemented.dart';
import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';
import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import '../../webdav_client/domain/webdav_auth_headers.dart';
import '../../webdav_client/domain/webdav_server_config.dart';
import 'favorite_models.dart';

class FavoriteFolderPlaybackSession {
  final List<PlayerQueueItem> playlist;
  final int initialIndex;

  const FavoriteFolderPlaybackSession({
    required this.playlist,
    required this.initialIndex,
  });
}

Future<void> openFavoriteFolderVideo({
  required BuildContext context,
  required FavoriteFolderEntry folder,
  required FavoriteVideoEntry video,
  required WebDavAccountRepository webDavAccountRepository,
}) async {
  try {
    final session = await buildFavoriteFolderPlaybackSession(
      folder: folder,
      initialVideoId: video.id,
      webDavAccountRepository: webDavAccountRepository,
    );
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context, rootNavigator: true).push(
      buildPlayerPageRoute(
        child: PlayerPage(
          playlist: session.playlist,
          initialIndex: session.initialIndex,
        ),
      ),
    );
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    showNotImplementedSnackBar(context, error.toString());
  }
}

Future<FavoriteFolderPlaybackSession> buildFavoriteFolderPlaybackSession({
  required FavoriteFolderEntry folder,
  required String initialVideoId,
  required WebDavAccountRepository webDavAccountRepository,
}) async {
  final builder = _FavoritePlayerItemBuilder(
    webDavAccountRepository: webDavAccountRepository,
  );
  final playlist = <PlayerQueueItem>[];
  for (final video in folder.videos) {
    playlist.add(await builder.build(video));
  }
  if (playlist.isEmpty) {
    throw StateError('当前收藏夹没有可播放视频。');
  }

  final initialIndex = playlist.indexWhere(
    (PlayerQueueItem item) => item.id == initialVideoId,
  );
  return FavoriteFolderPlaybackSession(
    playlist: List<PlayerQueueItem>.unmodifiable(playlist),
    initialIndex: initialIndex < 0 ? 0 : initialIndex,
  );
}

class _FavoritePlayerItemBuilder {
  final WebDavAccountRepository webDavAccountRepository;

  List<WebDavServerConfig>? _accounts;
  final Map<String, String?> _passwordCache = <String, String?>{};

  _FavoritePlayerItemBuilder({required this.webDavAccountRepository});

  Future<PlayerQueueItem> build(FavoriteVideoEntry video) {
    return switch (video.resolvedSourceKind) {
      MediaSourceKind.local => Future<PlayerQueueItem>.value(
        _buildLocalPlayerItem(video),
      ),
      MediaSourceKind.webDav => _buildWebDavPlayerItem(video),
      MediaSourceKind.other => Future<PlayerQueueItem>.value(
        _buildOtherPlayerItem(video),
      ),
    };
  }

  PlayerQueueItem _buildLocalPlayerItem(FavoriteVideoEntry video) {
    final path = video.playbackPath;
    if (path == null || path.trim().isEmpty) {
      throw StateError('本地收藏视频缺少文件路径，无法播放。');
    }

    return PlayerQueueItem(
      id: video.id,
      title: video.title,
      sourceLabel: video.sourceLabel ?? '本地视频',
      path: path,
      duration: Duration(milliseconds: video.durationMs ?? 0),
      sourceKind: MediaSourceKind.local,
      resolutionText: video.resolutionText,
      previewAspectRatio:
          video.previewAspectRatio ?? kDefaultPreviewAspectRatio,
      lastKnownPositionMs: video.lastKnownPositionMs,
      localVideoId: video.resolvedLocalVideoId,
      localVideoDateModified: video.resolvedLocalVideoDateModified,
    );
  }

  PlayerQueueItem _buildOtherPlayerItem(FavoriteVideoEntry video) {
    final sourceUri = video.sourceUri;
    if (sourceUri == null || sourceUri.trim().isEmpty) {
      throw StateError('远程收藏视频缺少播放地址，无法播放。');
    }

    return PlayerQueueItem(
      id: video.id,
      title: video.title,
      sourceLabel: video.sourceLabel ?? '远程视频',
      path: video.playbackPath,
      sourceUri: sourceUri,
      duration: Duration(milliseconds: video.durationMs ?? 0),
      sourceKind: MediaSourceKind.other,
      resolutionText: video.resolutionText,
      previewAspectRatio:
          video.previewAspectRatio ?? kDefaultPreviewAspectRatio,
      lastKnownPositionMs: video.lastKnownPositionMs,
    );
  }

  Future<PlayerQueueItem> _buildWebDavPlayerItem(
    FavoriteVideoEntry video,
  ) async {
    final accountId = video.webDavAccountId;
    if (accountId == null || accountId.trim().isEmpty) {
      throw StateError('WebDAV 收藏视频缺少账号信息，无法播放。');
    }

    final account = await _loadWebDavAccount(accountId);
    final password = await _loadPassword(accountId) ?? '';

    final sourceUri = video.sourceUri;
    if (sourceUri == null || sourceUri.trim().isEmpty) {
      throw StateError('WebDAV 收藏视频缺少播放地址，无法播放。');
    }

    return PlayerQueueItem(
      id: video.id,
      title: video.title,
      sourceLabel: video.sourceLabel ?? account.alias,
      path: video.playbackPath,
      sourceUri: sourceUri,
      duration: Duration(milliseconds: video.durationMs ?? 0),
      sourceKind: MediaSourceKind.webDav,
      resolutionText: video.resolutionText,
      previewAspectRatio:
          video.previewAspectRatio ?? kDefaultPreviewAspectRatio,
      lastKnownPositionMs: video.lastKnownPositionMs,
      localVideoId: video.resolvedLocalVideoId,
      localVideoDateModified: video.resolvedLocalVideoDateModified,
      webDavAccountId: account.id,
      httpHeaders: buildWebDavAuthHeaders(account: account, password: password),
    );
  }

  Future<WebDavServerConfig> _loadWebDavAccount(String accountId) async {
    final accounts = _accounts ??= await webDavAccountRepository.loadAccounts();
    for (final account in accounts) {
      if (account.id == accountId) {
        return account;
      }
    }

    throw StateError('未找到对应的 WebDAV 账号，无法播放该收藏视频。');
  }

  Future<String?> _loadPassword(String accountId) {
    final cached = _passwordCache[accountId];
    if (_passwordCache.containsKey(accountId)) {
      return Future<String?>.value(cached);
    }

    return webDavAccountRepository.loadPassword(accountId).then((
      String? password,
    ) {
      _passwordCache[accountId] = password;
      return password;
    });
  }
}
