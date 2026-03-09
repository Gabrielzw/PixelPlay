import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import '../../webdav_client/domain/contracts/webdav_browser_repository.dart';
import '../../webdav_client/domain/entities/webdav_entry.dart';
import '../../webdav_client/domain/webdav_server_config.dart';
import '../../webdav_client/presentation/controllers/webdav_browser_controller.dart';
import '../../webdav_client/presentation/widgets/webdav_browser_entry_widgets.dart';
import '../../webdav_client/presentation/widgets/webdav_browser_header.dart';
import '../../webdav_client/presentation/widgets/webdav_file_list.dart';
import '../../webdav_client/presentation/widgets/webdav_loading_state.dart';

class WebDavDirectoryPickerPage extends StatefulWidget {
  final WebDavServerConfig account;

  const WebDavDirectoryPickerPage({super.key, required this.account});

  @override
  State<WebDavDirectoryPickerPage> createState() =>
      _WebDavDirectoryPickerPageState();
}

class _WebDavDirectoryPickerPageState extends State<WebDavDirectoryPickerPage> {
  late final String _controllerTag;
  late final WebDavBrowserController _browserController;

  @override
  void initState() {
    super.initState();
    _controllerTag =
        'webdav_directory_picker_${widget.account.id}_${identityHashCode(this)}';
    _browserController = Get.put<WebDavBrowserController>(
      WebDavBrowserController(
        browserRepository: Get.find<WebDavBrowserRepository>(),
        accountRepository: Get.find<WebDavAccountRepository>(),
        account: widget.account,
      ),
      tag: _controllerTag,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _browserController.initialize();
    });
  }

  @override
  void dispose() {
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
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text('选择目录 · ${widget.account.alias}'),
          ),
          body: _buildBody(state),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(state.currentPath),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('选择当前目录'),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBody(WebDavBrowserViewState state) {
    if (state.isLoading && state.entries.isEmpty && state.error == null) {
      return const WebDavLoadingState();
    }
    if (state.error != null && state.entries.isEmpty) {
      return WebDavBrowserFailureView(
        message: state.error.toString(),
        onRetry: _browserController.reloadDirectory,
      );
    }

    final directories = state.visibleEntries
        .where((WebDavEntry entry) => entry.type == WebDavEntryType.directory)
        .toList(growable: false);
    if (directories.isEmpty) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: WebDavBreadcrumbBar(
              rootPath: state.rootPath,
              currentPath: state.currentPath,
              onTapPath: _browserController.openPath,
            ),
          ),
          Expanded(
            child: WebDavBrowserEmptyView(
              message: '当前目录下没有子目录，可直接选择当前目录。',
              onRefresh: _browserController.reloadDirectory,
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: WebDavBreadcrumbBar(
            rootPath: state.rootPath,
            currentPath: state.currentPath,
            onTapPath: _browserController.openPath,
          ),
        ),
        Expanded(
          child: WebDavFileList(
            storageKey: 'directory_picker_${widget.account.id}',
            entries: directories,
            onEntryTap: (WebDavEntry entry) {
              _browserController.openPath(entry.path);
            },
            onRefresh: _browserController.reloadDirectory,
          ),
        ),
      ],
    );
  }

  Future<void> _handleBackPressed() async {
    final wentBack = await _browserController.goBack();
    if (!mounted || wentBack) {
      return;
    }
    Navigator.of(context).maybePop();
  }

  void _handlePop(bool didPop, Object? result) {
    if (didPop) {
      return;
    }
    _handleBackPressed();
  }
}
