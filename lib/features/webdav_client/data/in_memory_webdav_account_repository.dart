import '../domain/contracts/webdav_account_repository.dart';
import '../domain/webdav_server_config.dart';

class InMemoryWebDavAccountRepository implements WebDavAccountRepository {
  final Map<String, String> _passwords = <String, String>{};
  final List<WebDavServerConfig> _accounts = <WebDavServerConfig>[];

  @override
  Future<List<WebDavServerConfig>> loadAccounts() async {
    return List<WebDavServerConfig>.unmodifiable(_accounts);
  }

  @override
  Future<WebDavServerConfig> saveAccount(
    WebDavServerConfig config, {
    required String password,
  }) async {
    _accounts.removeWhere((WebDavServerConfig item) => item.id == config.id);
    _accounts.add(config);
    _passwords[config.id] = password;
    return config;
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    _accounts.removeWhere((WebDavServerConfig item) => item.id == accountId);
    _passwords.remove(accountId);
  }

  @override
  Future<String?> loadPassword(String accountId) async {
    return _passwords[accountId];
  }
}
