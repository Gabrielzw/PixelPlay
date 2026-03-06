import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/contracts/webdav_password_store.dart';

const String _passwordKeyPrefix = 'webdav.account.';
const String _passwordKeySuffix = '.password';

class SecureStorageWebDavPasswordStore implements WebDavPasswordStore {
  final FlutterSecureStorage storage;

  const SecureStorageWebDavPasswordStore({required this.storage});

  @override
  Future<void> savePassword(String accountId, String password) async {
    await storage.write(key: _buildPasswordKey(accountId), value: password);
  }

  @override
  Future<String?> readPassword(String accountId) {
    return storage.read(key: _buildPasswordKey(accountId));
  }

  @override
  Future<void> deletePassword(String accountId) {
    return storage.delete(key: _buildPasswordKey(accountId));
  }

  String _buildPasswordKey(String accountId) {
    return '$_passwordKeyPrefix$accountId$_passwordKeySuffix';
  }
}
