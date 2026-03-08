import 'package:flutter/material.dart';

class FavoriteFolderFormPage extends StatefulWidget {
  final Set<String> existingTitles;

  const FavoriteFolderFormPage({super.key, required this.existingTitles});

  @override
  State<FavoriteFolderFormPage> createState() => _FavoriteFolderFormPageState();
}

class _FavoriteFolderFormPageState extends State<FavoriteFolderFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新建收藏夹'),
        actions: <Widget>[
          TextButton(onPressed: _submit, child: const Text('创建')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '收藏夹名称',
                hintText: '例如：电影、追番、稍后再看',
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            Text(
              '创建后会出现在收藏夹列表中，当前阶段仅在本次运行中生效。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    final normalizedTitle = _normalizeTitle(value ?? '');
    if (normalizedTitle.isEmpty) {
      return '收藏夹名称不能为空';
    }
    if (widget.existingTitles.contains(normalizedTitle)) {
      return '收藏夹名称已存在';
    }
    return null;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    Navigator.of(context).pop(_nameController.text.trim());
  }
}

String _normalizeTitle(String value) {
  return value.trim().toLowerCase();
}
