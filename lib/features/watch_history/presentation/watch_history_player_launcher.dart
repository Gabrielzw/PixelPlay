import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../shared/domain/media_source_kind.dart';
import '../../../shared/utils/not_implemented.dart';
import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';
import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import '../../webdav_client/domain/webdav_paths.dart';
import '../../webdav_client/domain/webdav_server_config.dart';
import '../domain/watch_history_repository.dart';

Future<void> openWatchHistoryRecord({
  required BuildContext context,
  required WatchHistoryRecord record,
  required WebDavAccountRepository webDavAccountRepository,
}) async {
  try {
    final item = await _buildPlayerItem(record, webDavAccountRepository);
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context, rootNavigator: true).push(
      buildPlayerPageRoute(
        child: PlayerPage(playlist: <PlayerQueueItem>[item]),
      ),
    );
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    showNotImplementedSnackBar(context, error.toString());
  }
}

Future<PlayerQueueItem> _buildPlayerItem(
  WatchHistoryRecord record,
  WebDavAccountRepository repository,
) {
  return switch (record.sourceKind) {
    MediaSourceKind.local => Future<PlayerQueueItem>.value(
      _buildLocalPlayerItem(record),
    ),
    MediaSourceKind.webDav => _buildWebDavPlayerItem(record, repository),
    MediaSourceKind.other => Future<PlayerQueueItem>.value(
      _buildOtherPlayerItem(record),
    ),
  };
}

PlayerQueueItem _buildLocalPlayerItem(WatchHistoryRecord record) {
  return PlayerQueueItem(
    id: record.mediaId,
    title: record.title,
    sourceLabel: record.sourceLabel,
    path: record.mediaPath,
    duration: Duration(milliseconds: record.durationMs),
    lastKnownPositionMs: record.positionMs,
    localVideoId: record.localVideoId,
    localVideoDateModified: record.localVideoDateModified,
  );
}

PlayerQueueItem _buildOtherPlayerItem(WatchHistoryRecord record) {
  final sourceUri = record.sourceUri;
  if (sourceUri == null || sourceUri.trim().isEmpty) {
    throw StateError(
      '\u5176\u4ed6\u6765\u6e90\u7684\u89c2\u770b\u8bb0\u5f55\u7f3a\u5c11\u64ad\u653e\u5730\u5740\uff0c\u65e0\u6cd5\u64ad\u653e\u3002',
    );
  }

  return PlayerQueueItem(
    id: record.mediaId,
    title: record.title,
    sourceLabel: record.sourceLabel,
    sourceUri: sourceUri,
    duration: Duration(milliseconds: record.durationMs),
    sourceKind: MediaSourceKind.other,
    lastKnownPositionMs: record.positionMs,
  );
}

Future<PlayerQueueItem> _buildWebDavPlayerItem(
  WatchHistoryRecord record,
  WebDavAccountRepository repository,
) async {
  final accountId = record.webDavAccountId;
  final entryPath = record.mediaPath;
  if (accountId == null || entryPath == null || entryPath.trim().isEmpty) {
    throw StateError(
      'WebDAV \u89c2\u770b\u8bb0\u5f55\u7f3a\u5c11\u5fc5\u8981\u4fe1\u606f\uff0c\u65e0\u6cd5\u64ad\u653e\u3002',
    );
  }

  final account = await _loadWebDavAccount(repository, accountId);
  final password = await repository.loadPassword(account.id);
  if (password == null || password.isEmpty) {
    throw StateError(
      '\u672a\u627e\u5230\u8be5 WebDAV \u8d26\u53f7\u7684\u5bc6\u7801\uff0c\u8bf7\u91cd\u65b0\u4fdd\u5b58\u8d26\u53f7\u540e\u518d\u8bd5\u3002',
    );
  }

  final authorization = base64Encode(
    utf8.encode('${account.username}:$password'),
  );

  return PlayerQueueItem(
    id: record.mediaId,
    title: record.title,
    sourceLabel: record.sourceLabel,
    path: entryPath,
    sourceUri: buildWebDavResourceUrl(
      baseUrl: account.url,
      path: entryPath,
    ).toString(),
    duration: Duration(milliseconds: record.durationMs),
    sourceKind: MediaSourceKind.webDav,
    lastKnownPositionMs: record.positionMs,
    webDavAccountId: account.id,
    httpHeaders: <String, String>{'Authorization': 'Basic $authorization'},
  );
}

Future<WebDavServerConfig> _loadWebDavAccount(
  WebDavAccountRepository repository,
  String accountId,
) async {
  final accounts = await repository.loadAccounts();
  for (final account in accounts) {
    if (account.id == accountId) {
      return account;
    }
  }
  throw StateError(
    '\u672a\u627e\u5230\u5bf9\u5e94\u7684 WebDAV \u8d26\u53f7\uff0c\u65e0\u6cd5\u64ad\u653e\u8be5\u5386\u53f2\u8bb0\u5f55\u3002',
  );
}
