import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/contracts/webdav_account_repository.dart';
import '../../domain/webdav_server_config.dart';

sealed class WebDavAccountsViewState {
  const WebDavAccountsViewState();
}

class WebDavAccountsLoadingState extends WebDavAccountsViewState {
  const WebDavAccountsLoadingState();
}

@immutable
class WebDavAccountsReadyState extends WebDavAccountsViewState {
  final List<WebDavServerConfig> accounts;

  const WebDavAccountsReadyState({required this.accounts});
}

@immutable
class WebDavAccountsFailureState extends WebDavAccountsViewState {
  final Object error;
  final StackTrace stackTrace;

  const WebDavAccountsFailureState({
    required this.error,
    required this.stackTrace,
  });
}

class WebDavAccountsController extends GetxController {
  final WebDavAccountRepository repository;
  final Rx<WebDavAccountsViewState> state = Rx<WebDavAccountsViewState>(
    const WebDavAccountsLoadingState(),
  );

  WebDavAccountsController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    refreshAccounts();
  }

  Future<void> refreshAccounts() async {
    state.value = const WebDavAccountsLoadingState();
    try {
      final accounts = await repository.loadAccounts();
      state.value = WebDavAccountsReadyState(accounts: _sortAccounts(accounts));
    } catch (error, stackTrace) {
      state.value = WebDavAccountsFailureState(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> saveAccount(
    WebDavServerConfig config, {
    required String password,
  }) async {
    await repository.saveAccount(config, password: password);
    await refreshAccounts();
  }

  Future<void> deleteAccount(String accountId) async {
    await repository.deleteAccount(accountId);
    await refreshAccounts();
  }

  Future<String> requirePassword(String accountId) async {
    return await repository.loadPassword(accountId) ?? '';
  }

  List<WebDavServerConfig> _sortAccounts(List<WebDavServerConfig> accounts) {
    final nextAccounts = List<WebDavServerConfig>.of(accounts);
    nextAccounts.sort(
      (WebDavServerConfig left, WebDavServerConfig right) =>
          left.alias.toLowerCase().compareTo(right.alias.toLowerCase()),
    );
    return List<WebDavServerConfig>.unmodifiable(nextAccounts);
  }
}
