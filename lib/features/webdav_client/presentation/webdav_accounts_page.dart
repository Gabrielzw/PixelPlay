import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/page_navigation.dart';
import '../../../shared/widgets/pp_dialog.dart';
import '../../../shared/widgets/pp_toast.dart';
import '../domain/webdav_server_config.dart';
import 'controllers/webdav_accounts_controller.dart';
import 'webdav_account_form_page.dart';
import 'webdav_browser_page.dart';

class WebDavAccountsPage extends GetView<WebDavAccountsController> {
  const WebDavAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络共享'),
        actions: <Widget>[
          IconButton(
            tooltip: '刷新',
            onPressed: controller.refreshAccounts,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: '添加账户',
            onPressed: () => _openAccountForm(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = controller.state.value;
    return switch (state) {
      WebDavAccountsLoadingState() => const Center(
        child: CircularProgressIndicator(),
      ),
      WebDavAccountsFailureState() => _AccountsFailureView(
        message: _formatError(state.error),
        onRetry: controller.refreshAccounts,
      ),
      WebDavAccountsReadyState() => _AccountsListView(
        accounts: state.accounts,
        onCreate: () => _openAccountForm(context),
        onEdit: (WebDavServerConfig account) =>
            _openAccountForm(context, account: account),
        onOpen: (WebDavServerConfig account) => _openBrowser(context, account),
        onDelete: (WebDavServerConfig account) =>
            _deleteAccount(context, account),
      ),
    };
  }

  Future<void> _openAccountForm(
    BuildContext context, {
    WebDavServerConfig? account,
  }) async {
    final saved = await pushRootPage<bool>(
      context,
      (_) => WebDavAccountFormPage(initialAccount: account),
    );
    if (saved != true || !context.mounted) {
      return;
    }

    PPToast.success(account == null ? '已添加 WebDAV 账户' : '已更新 WebDAV 账户');
  }

  void _openBrowser(BuildContext context, WebDavServerConfig account) {
    pushRootPage<void>(context, (_) => WebDavBrowserPage(account: account));
  }

  Future<void> _deleteAccount(
    BuildContext context,
    WebDavServerConfig account,
  ) async {
    final confirmed = await showPPConfirmDialog(
      context,
      title: '删除账户',
      message: '确定删除“${account.alias}”吗？该操作会同时清除保存的密码。',
      confirmLabel: '删除',
      icon: Icons.cloud_off_rounded,
      tone: PPDialogTone.destructive,
    );
    if (confirmed != true) {
      return;
    }

    try {
      await controller.deleteAccount(account.id);
      if (!context.mounted) {
        return;
      }
      PPToast.success('已删除 WebDAV 账户');
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      PPToast.error(error.toString());
    }
  }
}

class _AccountsListView extends StatelessWidget {
  final List<WebDavServerConfig> accounts;
  final VoidCallback onCreate;
  final ValueChanged<WebDavServerConfig> onEdit;
  final ValueChanged<WebDavServerConfig> onOpen;
  final ValueChanged<WebDavServerConfig> onDelete;

  const _AccountsListView({
    required this.accounts,
    required this.onCreate,
    required this.onEdit,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return _AccountsEmptyView(onCreate: onCreate);
    }

    return ListView.separated(
      key: const PageStorageKey<String>('webdav_accounts_list'),
      padding: const EdgeInsets.all(16),
      itemCount: accounts.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (BuildContext context, int index) {
        final account = accounts[index];
        return Card(
          child: ListTile(
            onTap: () => onOpen(account),
            leading: const CircleAvatar(child: Icon(Icons.cloud_outlined)),
            title: Text(account.alias),
            subtitle: Text('${account.username} · ${account.url}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  tooltip: '编辑账户',
                  onPressed: () => onEdit(account),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: '删除账户',
                  onPressed: () => onDelete(account),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccountsEmptyView extends StatelessWidget {
  final VoidCallback onCreate;

  const _AccountsEmptyView({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text('还没有 WebDAV 账户'),
            const SizedBox(height: 8),
            Text(
              '添加服务器后即可浏览远程目录中的视频文件。',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('添加账户'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountsFailureView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AccountsFailureView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
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
