import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/contracts/webdav_account_repository.dart';
import '../../domain/contracts/webdav_browser_repository.dart';
import '../../domain/entities/webdav_entry.dart';
import '../../domain/webdav_paths.dart';
import '../../domain/webdav_server_config.dart';

const Object _kKeepError = Object();

@immutable
class WebDavBrowserViewState {
  final String rootPath;
  final String currentPath;
  final List<WebDavEntry> entries;
  final bool isLoading;
  final Object? error;
  final String searchQuery;

  const WebDavBrowserViewState({
    required this.rootPath,
    required this.currentPath,
    this.entries = const <WebDavEntry>[],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  bool get isAtRootPath => currentPath == rootPath;

  List<WebDavEntry> get visibleEntries {
    final query = searchQuery.toLowerCase();
    if (query.isEmpty) {
      return entries;
    }

    return entries
        .where((WebDavEntry entry) => entry.name.toLowerCase().contains(query))
        .toList(growable: false);
  }

  WebDavBrowserViewState copyWith({
    String? rootPath,
    String? currentPath,
    List<WebDavEntry>? entries,
    bool? isLoading,
    Object? error = _kKeepError,
    String? searchQuery,
  }) {
    return WebDavBrowserViewState(
      rootPath: rootPath ?? this.rootPath,
      currentPath: currentPath ?? this.currentPath,
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _kKeepError) ? this.error : error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class WebDavBrowserController extends GetxController {
  final WebDavBrowserRepository browserRepository;
  final WebDavAccountRepository accountRepository;
  final WebDavServerConfig account;
  final Rx<WebDavBrowserViewState> state;

  String? _password;
  int _requestId = 0;

  WebDavBrowserController({
    required this.browserRepository,
    required this.accountRepository,
    required this.account,
    String? initialPath,
  }) : state = Rx<WebDavBrowserViewState>(
         _createInitialState(account: account, initialPath: initialPath),
       );

  Future<void> initialize() {
    return reloadDirectory();
  }

  Future<void> reloadDirectory() {
    return _loadCurrentPath();
  }

  void updateSearchQuery(String query) {
    final nextQuery = query.trim();
    if (nextQuery == state.value.searchQuery) {
      return;
    }

    state.value = state.value.copyWith(searchQuery: nextQuery);
  }

  Future<void> openPath(String path) async {
    final normalizedPath = normalizeWebDavPath(path);
    if (normalizedPath == state.value.currentPath) {
      return;
    }

    state.value = state.value.copyWith(
      currentPath: normalizedPath,
      searchQuery: '',
    );
    await _loadCurrentPath();
  }

  Future<bool> goBack() async {
    final parentPath = _findParentPath();
    if (parentPath == null) {
      return false;
    }

    await openPath(parentPath);
    return true;
  }

  Future<String> requirePassword() async {
    final cachedPassword = _password;
    if (cachedPassword != null && cachedPassword.isNotEmpty) {
      return cachedPassword;
    }

    final password = await accountRepository.loadPassword(account.id);
    if (password == null || password.isEmpty) {
      throw StateError('未找到该 WebDAV 账户的密码，请重新编辑并保存。');
    }

    _password = password;
    return password;
  }

  Future<void> _loadCurrentPath() async {
    final targetPath = state.value.currentPath;
    final requestId = ++_requestId;
    state.value = state.value.copyWith(isLoading: true, error: null);

    try {
      final password = await requirePassword();
      final entries = await browserRepository.readDirectory(
        account,
        password: password,
        path: targetPath,
      );
      if (_shouldDiscardResult(requestId, targetPath)) {
        return;
      }

      state.value = state.value.copyWith(
        entries: entries,
        isLoading: false,
        error: null,
      );
    } catch (error) {
      if (_shouldDiscardResult(requestId, targetPath)) {
        return;
      }

      state.value = state.value.copyWith(isLoading: false, error: error);
    }
  }

  bool _shouldDiscardResult(int requestId, String targetPath) {
    return isClosed ||
        requestId != _requestId ||
        targetPath != state.value.currentPath;
  }

  String? _findParentPath() {
    final browserState = state.value;
    if (browserState.isAtRootPath) {
      return null;
    }

    final currentSegments = _pathSegments(browserState.currentPath);
    final rootSegments = _pathSegments(browserState.rootPath);
    final parentLength = currentSegments.length - 1;
    if (parentLength <= rootSegments.length) {
      return browserState.rootPath;
    }

    final parentSegments = currentSegments.take(parentLength).join('/');
    return normalizeWebDavPath('/$parentSegments');
  }

  List<String> _pathSegments(String path) {
    return normalizeWebDavPath(path)
        .split('/')
        .where((String segment) => segment.isNotEmpty)
        .toList(growable: false);
  }

  static WebDavBrowserViewState _createInitialState({
    required WebDavServerConfig account,
    required String? initialPath,
  }) {
    final rootPath = resolveRelativeWebDavPath(
      baseUrl: account.url,
      path: account.rootPath,
    );
    final currentPath = resolveRelativeWebDavPath(
      baseUrl: account.url,
      path: initialPath ?? account.rootPath,
    );

    return WebDavBrowserViewState(
      rootPath: rootPath,
      currentPath: currentPath,
      isLoading: true,
    );
  }
}
