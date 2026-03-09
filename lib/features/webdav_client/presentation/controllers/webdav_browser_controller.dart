import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/contracts/webdav_account_repository.dart';
import '../../domain/contracts/webdav_browser_repository.dart';
import '../../domain/contracts/webdav_sort_preference_store.dart';
import '../../domain/entities/webdav_entry.dart';
import '../../domain/webdav_entry_sorting.dart';
import '../../domain/webdav_paths.dart';
import '../../domain/webdav_server_config.dart';
import '../../domain/webdav_sort_option.dart';

const Object _kKeepError = Object();

@immutable
class WebDavBrowserViewState {
  final String rootPath;
  final String currentPath;
  final List<WebDavEntry> entries;
  final bool isLoading;
  final Object? error;
  final String searchQuery;
  final WebDavSortOption sortOption;

  const WebDavBrowserViewState({
    required this.rootPath,
    required this.currentPath,
    this.entries = const <WebDavEntry>[],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.sortOption = WebDavSortOption.nameAsc,
  });

  bool get isAtRootPath => currentPath == rootPath;

  List<WebDavEntry> get visibleEntries {
    return filterAndSortWebDavEntries(
      entries: entries,
      searchQuery: searchQuery,
      sortOption: sortOption,
    );
  }

  WebDavBrowserViewState copyWith({
    String? rootPath,
    String? currentPath,
    List<WebDavEntry>? entries,
    bool? isLoading,
    Object? error = _kKeepError,
    String? searchQuery,
    WebDavSortOption? sortOption,
  }) {
    return WebDavBrowserViewState(
      rootPath: rootPath ?? this.rootPath,
      currentPath: currentPath ?? this.currentPath,
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _kKeepError) ? this.error : error,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class WebDavBrowserController extends GetxController {
  final WebDavBrowserRepository browserRepository;
  final WebDavAccountRepository accountRepository;
  final WebDavSortPreferenceStore sortPreferenceStore;
  final WebDavServerConfig account;
  final Rx<WebDavBrowserViewState> state;

  String? _password;
  int _requestId = 0;

  WebDavBrowserController({
    required this.browserRepository,
    required this.accountRepository,
    required this.sortPreferenceStore,
    required this.account,
    String? initialPath,
    String? rootPath,
  }) : state = Rx<WebDavBrowserViewState>(
         _createInitialState(
           account: account,
           initialPath: initialPath,
           rootPath: rootPath,
         ),
       );

  Future<void> initialize() async {
    try {
      final sortOption = await sortPreferenceStore.readSortOption();
      if (sortOption != null) {
        state.value = state.value.copyWith(sortOption: sortOption);
      }
      await reloadDirectory();
    } catch (error) {
      if (isClosed) {
        return;
      }
      state.value = state.value.copyWith(isLoading: false, error: error);
    }
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

  Future<void> updateSortOption(WebDavSortOption sortOption) async {
    final previousState = state.value;
    if (sortOption == previousState.sortOption) {
      return;
    }

    state.value = previousState.copyWith(sortOption: sortOption);
    try {
      await sortPreferenceStore.saveSortOption(sortOption);
    } catch (_) {
      if (!isClosed) {
        state.value = previousState;
      }
      rethrow;
    }
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
    if (cachedPassword != null) {
      return cachedPassword;
    }

    final password = await accountRepository.loadPassword(account.id) ?? '';
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
    required String? rootPath,
  }) {
    final resolvedRootPath = _resolveRootPath(account, rootPath);
    final resolvedCurrentPath = _resolveCurrentPath(
      account: account,
      initialPath: initialPath,
      rootPath: resolvedRootPath,
    );

    return WebDavBrowserViewState(
      rootPath: resolvedRootPath,
      currentPath: resolvedCurrentPath,
      isLoading: true,
    );
  }

  static String _resolveRootPath(WebDavServerConfig account, String? rootPath) {
    if (rootPath != null) {
      return normalizeWebDavPath(rootPath);
    }

    return resolveRelativeWebDavPath(
      baseUrl: account.url,
      path: account.rootPath,
    );
  }

  static String _resolveCurrentPath({
    required WebDavServerConfig account,
    required String? initialPath,
    required String rootPath,
  }) {
    if (initialPath == null || initialPath.trim().isEmpty) {
      return rootPath;
    }

    return normalizeWebDavPath(initialPath);
  }
}
