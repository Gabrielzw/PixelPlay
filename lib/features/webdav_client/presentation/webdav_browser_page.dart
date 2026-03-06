import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';
import '../domain/contracts/webdav_browser_repository.dart';
import '../domain/entities/webdav_entry.dart';
import '../domain/webdav_paths.dart';
import '../domain/webdav_server_config.dart';
import 'controllers/webdav_accounts_controller.dart';
import 'widgets/webdav_browser_entry_widgets.dart';
import 'widgets/webdav_browser_header.dart';

class WebDavBrowserPage extends StatefulWidget {
  final WebDavServerConfig account;
  final String? path;

  const WebDavBrowserPage({super.key, required this.account, this.path});

  @override
  State<WebDavBrowserPage> createState() => _WebDavBrowserPageState();
}

class _WebDavBrowserPageState extends State<WebDavBrowserPage> {
  late final WebDavBrowserRepository _browserRepository;
  late final WebDavAccountsController _accountsController;
  late final TextEditingController _searchController;
  late final String _rootPath;

  List<WebDavEntry> _entries = const <WebDavEntry>[];
  Object? _error;
  bool _isLoading = true;
  String _searchQuery = '';
  late String _currentPath;

  bool get _isAtRootPath => _currentPath == _rootPath;

  List<WebDavEntry> get _visibleEntries {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) {
      return _entries;
    }
    return _entries
        .where((WebDavEntry entry) => entry.name.toLowerCase().contains(query))
        .toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _browserRepository = Get.find<WebDavBrowserRepository>();
    _accountsController = Get.find<WebDavAccountsController>();
    _rootPath = _resolveRootPath(widget.account);
    _currentPath = _resolveCurrentPath(widget.account, widget.path);
    _searchController = TextEditingController()
      ..addListener(_handleSearchChanged);
    _loadEntries();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isAtRootPath,
      onPopInvokedWithResult: _handlePop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: '返回',
            onPressed: _handleBackPressed,
            icon: const Icon(Icons.arrow_back),
          ),
          titleSpacing: 0,
          title: WebDavBreadcrumbBar(
            rootPath: _rootPath,
            currentPath: _currentPath,
            onTapPath: _openPath,
          ),
          actions: <Widget>[
            IconButton(
              tooltip: '刷新',
              onPressed: _loadEntries,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: WebDavSearchField(controller: _searchController),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return WebDavBrowserFailureView(
        message: _formatError(_error!),
        onRetry: _loadEntries,
      );
    }
    if (_visibleEntries.isEmpty) {
      return WebDavBrowserEmptyView(
        message: _searchQuery.isEmpty
            ? '当前目录下没有可显示的视频或子目录。'
            : '没有匹配“$_searchQuery”的文件或文件夹。',
        onRefresh: _loadEntries,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEntries,
      child: ListView.separated(
        key: PageStorageKey<String>('webdav_browser_$_currentPath'),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: _visibleEntries.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (BuildContext context, int index) {
          final entry = _visibleEntries[index];
          return WebDavEntryCard(
            entry: entry,
            onTap: () => _handleEntryTap(context, entry),
          );
        },
      ),
    );
  }

  void _handlePop(bool didPop, Object? result) {
    if (didPop || _isAtRootPath) {
      return;
    }
    _navigateToParentPath();
  }

  void _handleBackPressed() {
    if (_isAtRootPath) {
      Navigator.of(context).maybePop();
      return;
    }
    _navigateToParentPath();
  }

  void _handleSearchChanged() {
    final nextQuery = _searchController.text.trim();
    if (nextQuery == _searchQuery) {
      return;
    }
    setState(() => _searchQuery = nextQuery);
  }

  Future<void> _loadEntries() async {
    final targetPath = _currentPath;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final password = await _accountsController.requirePassword(
        widget.account.id,
      );
      final entries = await _browserRepository.readDirectory(
        widget.account,
        password: password,
        path: targetPath,
      );
      if (!mounted || targetPath != _currentPath) {
        return;
      }
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted || targetPath != _currentPath) {
        return;
      }
      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _openPath(String path) async {
    final normalizedPath = normalizeWebDavPath(path);
    if (normalizedPath == _currentPath) {
      return;
    }

    _searchController.clear();
    setState(() => _currentPath = normalizedPath);
    await _loadEntries();
  }

  void _navigateToParentPath() {
    final parentPath = _findParentPath();
    if (parentPath == null) {
      Navigator.of(context).maybePop();
      return;
    }
    _openPath(parentPath);
  }

  String? _findParentPath() {
    if (_isAtRootPath) {
      return null;
    }

    final currentSegments = _pathSegments(_currentPath);
    final rootSegments = _pathSegments(_rootPath);
    final parentLength = currentSegments.length - 1;
    if (parentLength <= rootSegments.length) {
      return _rootPath;
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

  String _resolveRootPath(WebDavServerConfig account) {
    return resolveRelativeWebDavPath(
      baseUrl: account.url,
      path: account.rootPath,
    );
  }

  String _resolveCurrentPath(WebDavServerConfig account, String? path) {
    final sourcePath = path ?? account.rootPath;
    return resolveRelativeWebDavPath(baseUrl: account.url, path: sourcePath);
  }

  void _handleEntryTap(BuildContext context, WebDavEntry entry) {
    switch (entry.type) {
      case WebDavEntryType.directory:
        _openPath(entry.path);
        break;
      case WebDavEntryType.video:
        final playlist = _entries
            .where((WebDavEntry item) => item.type == WebDavEntryType.video)
            .map(_mapPlayerItem)
            .toList(growable: false);
        final initialIndex = playlist.indexWhere(
          (PlayerQueueItem item) => item.id == entry.path,
        );
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute<void>(
            builder: (_) => PlayerPage(
              playlist: playlist,
              initialIndex: initialIndex < 0 ? 0 : initialIndex,
            ),
          ),
        );
        break;
      case WebDavEntryType.other:
        break;
    }
  }

  PlayerQueueItem _mapPlayerItem(WebDavEntry entry) {
    return PlayerQueueItem(
      id: entry.path,
      title: entry.name,
      sourceLabel: '${widget.account.alias} · $_currentPath',
      path: entry.path,
      isRemote: true,
    );
  }
}

String _formatError(Object error) {
  final text = error.toString();
  return text
      .replaceFirst('Exception: ', '')
      .replaceFirst('Bad state: ', '')
      .trim();
}
