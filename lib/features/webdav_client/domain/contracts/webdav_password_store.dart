abstract interface class WebDavPasswordStore {
  Future<void> savePassword(String accountId, String password);

  Future<String?> readPassword(String accountId);

  Future<void> deletePassword(String accountId);
}
