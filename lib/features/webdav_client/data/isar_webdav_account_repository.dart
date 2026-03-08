import 'package:isar_community/isar.dart';

import '../../../shared/data/isar/schemas/webdav_account_isar_model.dart';
import '../domain/contracts/webdav_account_repository.dart';
import '../domain/contracts/webdav_password_store.dart';
import '../domain/webdav_server_config.dart';

class IsarWebDavAccountRepository implements WebDavAccountRepository {
  final Isar isar;
  final WebDavPasswordStore passwordStore;

  const IsarWebDavAccountRepository({
    required this.isar,
    required this.passwordStore,
  });

  @override
  Future<List<WebDavServerConfig>> loadAccounts() async {
    final accounts = await isar.webDavAccountIsarModels.where().findAll();
    return List<WebDavServerConfig>.unmodifiable(
      accounts.map((WebDavAccountIsarModel account) => account.toDomain()),
    );
  }

  @override
  Future<WebDavServerConfig> saveAccount(
    WebDavServerConfig config, {
    required String password,
  }) async {
    final storedAccount = await _findAccount(config.id);
    final nextAccount = WebDavAccountIsarModel.fromDomain(
      config,
      id: storedAccount?.id,
    );

    await isar.writeTxn(() async {
      await isar.webDavAccountIsarModels.put(nextAccount);
    });
    await passwordStore.savePassword(config.id, password);
    return config;
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    final storedAccount = await _findAccount(accountId);
    await isar.writeTxn(() async {
      if (storedAccount != null) {
        await isar.webDavAccountIsarModels.delete(storedAccount.id);
      }
    });
    await passwordStore.deletePassword(accountId);
  }

  @override
  Future<String?> loadPassword(String accountId) {
    return passwordStore.readPassword(accountId);
  }

  Future<WebDavAccountIsarModel?> _findAccount(String accountId) {
    return isar.webDavAccountIsarModels
        .filter()
        .accountIdEqualTo(accountId)
        .findFirst();
  }
}
