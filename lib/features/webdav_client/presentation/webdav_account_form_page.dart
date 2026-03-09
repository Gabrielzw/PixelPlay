import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/contracts/webdav_browser_repository.dart';
import '../domain/webdav_paths.dart';
import '../domain/webdav_server_config.dart';
import 'controllers/webdav_accounts_controller.dart';

class WebDavAccountFormPage extends StatefulWidget {
  final WebDavServerConfig? initialAccount;

  const WebDavAccountFormPage({super.key, this.initialAccount});

  @override
  State<WebDavAccountFormPage> createState() => _WebDavAccountFormPageState();
}

class _WebDavAccountFormPageState extends State<WebDavAccountFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _aliasController;
  late final TextEditingController _urlController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final WebDavAccountsController _accountsController;
  late final WebDavBrowserRepository _browserRepository;

  bool _isSaving = false;
  bool _isTesting = false;
  bool _obscurePassword = true;

  bool get _isEditing => widget.initialAccount != null;

  @override
  void initState() {
    super.initState();
    final account = widget.initialAccount;
    _aliasController = TextEditingController(text: account?.alias ?? '');
    _urlController = TextEditingController(text: account?.url.toString() ?? '');
    _usernameController = TextEditingController(text: account?.username ?? '');
    _passwordController = TextEditingController();
    _accountsController = Get.find<WebDavAccountsController>();
    _browserRepository = Get.find<WebDavBrowserRepository>();
  }

  @override
  void dispose() {
    _aliasController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑 WebDAV 账户' : '添加 WebDAV 账户'),
        actions: <Widget>[
          TextButton(
            onPressed: _isSaving ? null : _submit,
            child: Text(_isSaving ? '保存中...' : '保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _aliasController,
              decoration: const InputDecoration(
                labelText: 'WebDAV 名称',
                hintText: '请输入 WebDAV 名称',
              ),
              textInputAction: TextInputAction.next,
              validator: _validateRequired,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: '服务器地址',
                hintText: 'http(s)://xxxxxx/dav',
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              validator: _validateUrl,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '用户名',
                hintText: '请输入用户名（可选）',
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '密码',
                hintText: '请输入密码（可选）',
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _isTesting ? null : _testConnection,
              icon: _buildTestingIcon(),
              label: Text(_isTesting ? '测试中...' : '测试连接'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestingIcon() {
    if (_isTesting) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return const Icon(Icons.network_check_outlined);
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '该字段不能为空';
    }

    return null;
  }

  String? _validateUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '服务器地址不能为空';
    }

    final uri = Uri.tryParse(text);
    final hasValidScheme = uri?.scheme == 'http' || uri?.scheme == 'https';
    if (uri == null || !hasValidScheme || uri.host.isEmpty) {
      return '请输入有效的 http 或 https 地址';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_isFormValid()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final config = _buildConfig();
      final password = await _resolvePassword();
      await _accountsController.saveAccount(config, password: password);
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error) {
      _showMessage(_formatError(error));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _testConnection() async {
    if (!_isFormValid()) {
      return;
    }

    setState(() => _isTesting = true);
    try {
      final config = _buildConfig();
      final password = await _resolvePassword();
      await _browserRepository.verifyConnection(config, password: password);
      _showMessage('连接成功，可以正常访问目录。');
    } catch (error) {
      _showMessage(_formatError(error));
    } finally {
      if (mounted) {
        setState(() => _isTesting = false);
      }
    }
  }

  bool _isFormValid() {
    final formState = _formKey.currentState;
    if (formState == null) {
      return false;
    }

    return formState.validate();
  }

  WebDavServerConfig _buildConfig() {
    final initialAccount = widget.initialAccount;
    final normalizedUrl = normalizeWebDavUrl(_urlController.text);
    return WebDavServerConfig(
      id: initialAccount?.id ?? createWebDavAccountId(),
      alias: _aliasController.text.trim(),
      url: normalizedUrl,
      username: _usernameController.text.trim(),
      rootPath: kWebDavRootPath,
    );
  }

  Future<String> _resolvePassword() async {
    final inputPassword = _passwordController.text.trim();
    if (inputPassword.isNotEmpty) {
      return inputPassword;
    }

    final initialAccount = widget.initialAccount;
    if (initialAccount == null) {
      return '';
    }

    return await _accountsController.repository.loadPassword(
          initialAccount.id,
        ) ??
        '';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

String _formatError(Object error) {
  final text = error.toString();
  return text
      .replaceFirst('Exception: ', '')
      .replaceFirst('Bad state: ', '')
      .trim();
}
