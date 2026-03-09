import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/pp_toast.dart';
import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';
import '../domain/contracts/webdav_account_repository.dart';
import '../domain/contracts/webdav_browser_repository.dart';
import '../domain/entities/webdav_entry.dart';
import '../domain/webdav_paths.dart';
import '../domain/webdav_server_config.dart';
import 'controllers/webdav_browser_controller.dart';
import 'widgets/webdav_browser_entry_widgets.dart';
import 'widgets/webdav_browser_header.dart';
import 'widgets/webdav_file_list.dart';
import 'widgets/webdav_loading_state.dart';

class WebDavBrowserPage extends StatefulWidget {
  final WebDavServerConfig account;
  final String? path;

  const WebDavBrowserPage({super.key, required this.account, this.path});

  @override
  State<WebDavBrowserPage> createState() => _WebDavBrowserPageState();
}

class _WebDavBrowserPageState extends State<WebDavBrowserPage> {
  late final TextEditingController _searchController;
  late final String _controllerTag;
  late final WebDavBrowserController _browserController;

  @override
  void initState() {
    super.initState();
    _controllerTag =
        'webdav_browser_${widget.account.id}_${identityHashCode(this)}';
    _browserController = Get.put<WebDavBrowserController>(
      WebDavBrowserController(
        browserRepository: Get.find<WebDavBrowserRepository>(),
        accountRepository: Get.find<WebDavAccountRepository>(),
        account: widget.account,
        initialPath: widget.path,
      ),
      tag: _controllerTag,
    );
    _searchController = TextEditingController()
      ..addListener(_handleSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _browserController.initialize();
    });
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    Get.delete<WebDavBrowserController>(tag: _controllerTag, force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = _browserController.state.value;
      return PopScope(
        canPop: state.isAtRootPath,
        onPopInvokedWithResult: _handlePop,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: '返回',
              onPressed: _handleBackPressed,
              onLongPress: _handleBackLongPress,
              icon: const Icon(Icons.arrow_back),
            ),
            titleSpacing: 0,
            title: WebDavBreadcrumbBar(
              rootPath: state.rootPath,
              currentPath: state.currentPath,
              onTapPath: _openPath,
            ),
            actions: <Widget>[
              IconButton(
                tooltip: '刷新',
                onPressed: _browserController.reloadDirectory,
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
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: Duration.zero,
                  switchInCurve: Curves.easeOutCubic,
                  transitionBuilder: _buildContentTransition,
                  child: _buildBody(context, state),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, WebDavBrowserViewState state) {
    if (state.isLoading) {
      return const WebDavLoadingState(key: ValueKey<String>('loading'));
    }
    if (state.error != null) {
      return WebDavBrowserFailureView(
        key: const ValueKey<String>('error'),
        message: _formatError(state.error!),
        onRetry: _browserController.reloadDirectory,
      );
    }
    if (state.visibleEntries.isEmpty) {
      return WebDavBrowserEmptyView(
        key: ValueKey<String>(
          'empty_${state.currentPath}_${state.searchQuery}',
        ),
        message: _buildEmptyMessage(state.searchQuery),
        onRefresh: _browserController.reloadDirectory,
      );
    }

    return WebDavFileList(
      key: ValueKey<String>('${state.currentPath}_${state.searchQuery}'),
      storageKey: state.currentPath,
      entries: state.visibleEntries,
      onEntryTap: (WebDavEntry entry) => _handleEntryTap(context, entry, state),
      onRefresh: _browserController.reloadDirectory,
    );
  }

  Widget _buildContentTransition(Widget child, Animation<double> animation) {
    final position = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(animation);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: position, child: child),
    );
  }

  void _handlePop(bool didPop, Object? result) {
    if (didPop) {
      return;
    }
    _navigateBack();
  }

  Future<void> _handleBackPressed() {
    return _navigateBack();
  }

  void _handleBackLongPress() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  void _handleSearchChanged() {
    _browserController.updateSearchQuery(_searchController.text);
  }

  Future<void> _openPath(String path) async {
    _clearSearchField();
    await _browserController.openPath(path);
  }

  Future<void> _navigateBack() async {
    _clearSearchField();
    final didNavigate = await _browserController.goBack();
    if (!didNavigate && mounted) {
      Navigator.of(context).maybePop();
    }
  }

  void _clearSearchField() {
    if (_searchController.text.isEmpty) {
      return;
    }
    _searchController.clear();
  }

  Future<void> _handleEntryTap(
    BuildContext context,
    WebDavEntry entry,
    WebDavBrowserViewState state,
  ) async {
    switch (entry.type) {
      case WebDavEntryType.directory:
        await _openPath(entry.path);
        return;
      case WebDavEntryType.other:
        return;
      case WebDavEntryType.video:
        break;
    }

    try {
      final password = await _browserController.requirePassword();
      if (!context.mounted) {
        return;
      }

      final videoEntries = state.visibleEntries
          .where((WebDavEntry item) => item.type == WebDavEntryType.video)
          .toList(growable: false);
      if (videoEntries.isEmpty) {
        return;
      }

      final playlist = videoEntries
          .map(
            (WebDavEntry item) => _mapPlayerItem(
              entry: item,
              password: password,
              currentPath: state.currentPath,
            ),
          )
          .toList(growable: false);
      final initialIndex = playlist.indexWhere(
        (PlayerQueueItem item) => item.id == entry.path,
      );

      await Navigator.of(context, rootNavigator: true).push(
        buildPlayerPageRoute(
          child: PlayerPage(
            playlist: playlist,
            initialIndex: initialIndex < 0 ? 0 : initialIndex,
          ),
        ),
      );
    } catch (error) {
      PPToast.error(_formatError(error));
    }
  }

  PlayerQueueItem _mapPlayerItem({
    required WebDavEntry entry,
    required String password,
    required String currentPath,
  }) {
    final authorization = base64Encode(
      utf8.encode('${widget.account.username}:$password'),
    );

    return PlayerQueueItem(
      id: entry.path,
      title: entry.name,
      sourceLabel: '${widget.account.alias}$currentPath',
      path: entry.path,
      sourceUri: buildWebDavResourceUrl(
        baseUrl: widget.account.url,
        path: entry.path,
      ).toString(),
      isRemote: true,
      webDavAccountId: widget.account.id,
      httpHeaders: <String, String>{'Authorization': 'Basic $authorization'},
    );
  }

  String _buildEmptyMessage(String searchQuery) {
    if (searchQuery.isEmpty) {
      return '当前目录下没有可显示的视频或子目录。';
    }
    return '没有匹配“$searchQuery”的文件或文件夹。';
  }
}

String _formatError(Object error) {
  final text = error.toString();
  return text
      .replaceFirst('Exception: ', '')
      .replaceFirst('Bad state: ', '')
      .trim();
}
