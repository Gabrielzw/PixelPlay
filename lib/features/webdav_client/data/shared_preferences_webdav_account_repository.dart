import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/contracts/webdav_account_repository.dart';
import '../domain/contracts/webdav_password_store.dart';
import '../domain/webdav_paths.dart';
import '../domain/webdav_server_config.dart';

const String _accountsStorageKey = 'webdav.accounts.v1';

class SharedPreferencesWebDavAccountRepository
    implements WebDavAccountRepository {
  final SharedPreferences preferences;
  final WebDavPasswordStore passwordStore;

  const SharedPreferencesWebDavAccountRepository({
    required this.preferences,
    required this.passwordStore,
  });

  @override
  Future<List<WebDavServerConfig>> loadAccounts() async {
    return _readAccounts();
  }

  @override
  Future<WebDavServerConfig> saveAccount(
    WebDavServerConfig config, {
    required String password,
  }) async {
    final normalizedConfig = _normalizeConfig(config);
    final accounts = await _readAccounts();
    final nextAccounts = _mergeAccount(accounts, normalizedConfig);
    await _writeAccounts(nextAccounts);
    await passwordStore.savePassword(normalizedConfig.id, password);
    return normalizedConfig;
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    final accounts = await _readAccounts();
    final nextAccounts = accounts
        .where((WebDavServerConfig account) => account.id != accountId)
        .toList(growable: false);
    await _writeAccounts(nextAccounts);
    await passwordStore.deletePassword(accountId);
  }

  @override
  Future<String?> loadPassword(String accountId) {
    return passwordStore.readPassword(accountId);
  }

  Future<List<WebDavServerConfig>> _readAccounts() async {
    final rawJson = preferences.getString(_accountsStorageKey);
    if (rawJson == null || rawJson.isEmpty) {
      return const <WebDavServerConfig>[];
    }

    final dynamic decoded = jsonDecode(rawJson);
    if (decoded is! List<dynamic>) {
      throw const FormatException('WebDAV 账户数据格式无效。');
    }

    return decoded
        .map(
          (dynamic item) => _normalizeConfig(
            WebDavServerConfig.fromJson(
              Map<String, Object?>.from(item as Map<Object?, Object?>),
            ),
          ),
        )
        .toList(growable: false);
  }

  Future<void> _writeAccounts(List<WebDavServerConfig> accounts) async {
    final payload = jsonEncode(
      accounts.map((WebDavServerConfig item) => item.toJson()).toList(),
    );
    final saved = await preferences.setString(_accountsStorageKey, payload);
    if (!saved) {
      throw StateError('保存 WebDAV 账户失败。');
    }
  }

  List<WebDavServerConfig> _mergeAccount(
    List<WebDavServerConfig> accounts,
    WebDavServerConfig config,
  ) {
    final nextAccounts =
        accounts
            .where((WebDavServerConfig account) => account.id != config.id)
            .toList(growable: true)
          ..add(config);
    return List<WebDavServerConfig>.unmodifiable(nextAccounts);
  }

  WebDavServerConfig _normalizeConfig(WebDavServerConfig config) {
    final normalizedUrl = normalizeWebDavUrl(config.url.toString());
    final relativeRootPath = resolveRelativeWebDavPath(
      baseUrl: normalizedUrl,
      path: config.rootPath,
    );
    return config.copyWith(url: normalizedUrl, rootPath: relativeRootPath);
  }
}
