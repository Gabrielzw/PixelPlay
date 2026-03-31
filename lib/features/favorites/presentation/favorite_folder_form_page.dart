import 'package:flutter/material.dart';

class FavoriteFolderFormPage extends StatefulWidget {
  final Set<String> existingTitles;
  final String? initialTitle;
  final String pageTitle;
  final String submitLabel;
  final String description;

  const FavoriteFolderFormPage({
    super.key,
    required this.existingTitles,
    this.initialTitle,
    this.pageTitle = '\u65b0\u5efa\u6536\u85cf\u5939',
    this.submitLabel = '\u521b\u5efa',
    this.description =
        '\u521b\u5efa\u540e\u4f1a\u51fa\u73b0\u5728\u6536\u85cf\u5939\u5217\u8868\u4e2d\u3002',
  });

  @override
  State<FavoriteFolderFormPage> createState() => _FavoriteFolderFormPageState();
}

class _FavoriteFolderFormPageState extends State<FavoriteFolderFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTitle ?? '');
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
        title: Text(widget.pageTitle),
        actions: <Widget>[
          TextButton(onPressed: _submit, child: Text(widget.submitLabel)),
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
                labelText: '\u6536\u85cf\u5939\u540d\u79f0',
                hintText:
                    '\u4f8b\u5982\uff1a\u7535\u5f71\u3001\u8ffd\u756a\u3001\u7a0d\u540e\u518d\u770b',
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
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
      return '\u6536\u85cf\u5939\u540d\u79f0\u4e0d\u80fd\u4e3a\u7a7a';
    }
    if (widget.existingTitles.contains(normalizedTitle)) {
      return '\u6536\u85cf\u5939\u540d\u79f0\u5df2\u5b58\u5728';
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
