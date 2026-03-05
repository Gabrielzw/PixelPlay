import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import '../domain/webdav_server_config.dart';
import 'webdav_account_form_page.dart';
import 'webdav_browser_page.dart';

final Uri kDemoNasUri = Uri.parse('https://nas.example.com/dav');

final Uri kDemoCloudUri = Uri.parse('https://cloud.example.com/webdav');

final List<WebDavServerConfig> kDemoAccounts = <WebDavServerConfig>[
  WebDavServerConfig(
    alias: '示例 NAS',
    url: kDemoNasUri,
    username: 'demo',
    rootPath: '/',
  ),
  WebDavServerConfig(
    alias: '示例 云盘',
    url: kDemoCloudUri,
    username: 'demo',
    rootPath: '/videos',
  ),
];

class WebDavAccountsPage extends StatelessWidget {
  const WebDavAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _WebDavAccountsScaffold();
  }
}

class _WebDavAccountsScaffold extends StatelessWidget {
  const _WebDavAccountsScaffold();

  void _openAccountForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const WebDavAccountFormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络共享'),
        actions: <Widget>[
          IconButton(
            tooltip: '添加账户',
            onPressed: () => _openAccountForm(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const _WebDavAccountsBody(),
    );
  }
}

class _WebDavAccountsBody extends StatelessWidget {
  const _WebDavAccountsBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const UiSkeletonNotice(message: 'UI 骨架阶段：账户增删改查、安全存储与真实目录请求尚未接入。'),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            key: const PageStorageKey<String>('webdav_accounts_list'),
            padding: const EdgeInsets.all(16),
            itemCount: kDemoAccounts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final account = kDemoAccounts[index];
              return _AccountTile(account: account);
            },
          ),
        ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  final WebDavServerConfig account;

  const _AccountTile({required this.account});

  void _openBrowser(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WebDavBrowserPage(account: account),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => _openBrowser(context),
        title: Text(account.alias),
        subtitle: Text(account.url.toString()),
        trailing: IconButton(
          tooltip: '编辑',
          onPressed: () => showNotImplementedSnackBar(context, '编辑账户（未接入）'),
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}
