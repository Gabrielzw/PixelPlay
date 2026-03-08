import 'dart:convert';

import 'package:flutter/material.dart';

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
    final item = record.isRemote
        ? await _buildWebDavPlayerItem(record, webDavAccountRepository)
        : _buildLocalPlayerItem(record);
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

Future<PlayerQueueItem> _buildWebDavPlayerItem(
  WatchHistoryRecord record,
  WebDavAccountRepository repository,
) async {
  final accountId = record.webDavAccountId;
  final entryPath = record.mediaPath;
  if (accountId == null || entryPath == null || entryPath.trim().isEmpty) {
    throw StateError('WebDAV 观看记录缺少必要信息，无法播放。');
  }

  final account = await _loadWebDavAccount(repository, accountId);
  final password = await repository.loadPassword(account.id);
  if (password == null || password.isEmpty) {
    throw StateError('未找到该 WebDAV 账号的密码，请重新保存账号后再试。');
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
    isRemote: true,
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
  throw StateError('未找到对应的 WebDAV 账号，无法播放该历史记录。');
}
