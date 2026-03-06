import '../webdav_server_config.dart';

abstract interface class WebDavAccountRepository {
  Future<List<WebDavServerConfig>> loadAccounts();

  Future<WebDavServerConfig> saveAccount(
    WebDavServerConfig config, {
    required String password,
  });

  Future<void> deleteAccount(String accountId);

  Future<String?> loadPassword(String accountId);
}
