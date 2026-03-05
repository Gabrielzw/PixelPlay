import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';

class WebDavAccountFormPage extends StatelessWidget {
  const WebDavAccountFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _WebDavAccountFormScaffold();
  }
}

class _WebDavAccountFormScaffold extends StatelessWidget {
  const _WebDavAccountFormScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebDAV 账户'),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                showNotImplementedSnackBar(context, '保存（未接入安全存储/校验）'),
            child: const Text('保存'),
          ),
        ],
      ),
      body: const _WebDavAccountFormBody(),
    );
  }
}

class _WebDavAccountFormBody extends StatelessWidget {
  const _WebDavAccountFormBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const UiSkeletonNotice(message: 'UI 骨架阶段：字段校验、连通性测试与安全存储尚未接入。'),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: '名称',
            hintText: '例如：家里 NAS',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: '服务器地址',
            hintText: 'https://example.com/dav',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: '用户名',
            border: OutlineInputBorder(),
          ),
          autofillHints: const <String>[AutofillHints.username],
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: '密码',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          autofillHints: const <String>[AutofillHints.password],
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: '根路径限制（可选）',
            hintText: '/videos',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
