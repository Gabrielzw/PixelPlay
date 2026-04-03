import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/page_navigation.dart';
import '../../../shared/widgets/settings/settings_shell.dart';
import '../domain/settings_controller.dart';
import 'settings_catalog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _queryController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final List<SettingsMenuEntry> _menuEntries = buildSettingsMenuEntries();
  final List<SettingsSearchEntry> _searchEntries = buildSettingsSearchEntries();
  late final SettingsController _controller;

  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SettingsController>();
    _queryController.addListener(_handleQueryChanged);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _queryController
      ..removeListener(_handleQueryChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = _controller.settings.value;
      final normalizedQuery = normalizeSettingsSearchQuery(_query);
      final results = normalizedQuery.isEmpty
          ? const <SettingsSearchEntry>[]
          : _searchEntries
                .where((SettingsSearchEntry entry) {
                  return entry.matches(normalizedQuery, settings);
                })
                .toList(growable: false);

      return SettingsOverviewScaffold(
        title: '设置',
        searchBar: _SettingsSearchField(
          controller: _queryController,
          focusNode: _searchFocusNode,
          onClear: _clearQuery,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: normalizedQuery.isEmpty
              ? _SettingsMenuList(
                  key: const ValueKey<String>('settings_menu'),
                  entries: _menuEntries,
                  onOpenPage: _openPage,
                )
              : _SettingsSearchResults(
                  key: ValueKey<String>('settings_results_$_query'),
                  query: _query,
                  results: results,
                  onOpenPage: _openPage,
                  subtitleBuilder: (SettingsSearchEntry entry) {
                    return entry.buildSubtitle(settings);
                  },
                ),
        ),
      );
    });
  }

  void _handleQueryChanged() {
    final nextQuery = _queryController.text;
    if (nextQuery == _query) {
      return;
    }

    setState(() {
      _query = nextQuery;
    });
  }

  void _clearQuery() {
    _queryController.clear();
  }

  Future<void> _openPage(SettingsPageFactory pageFactory) async {
    _searchFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    await pushRootPage<void>(context, (_) => pageFactory());
  }
}

class _SettingsSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;

  const _SettingsSearchField({
    required this.controller,
    required this.focusNode,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
      decoration: InputDecoration(
        hintText: '搜索设置项...',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        prefixIcon: const Icon(Icons.search_rounded, size: 18),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: '清空搜索',
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

class _SettingsMenuList extends StatelessWidget {
  final List<SettingsMenuEntry> entries;
  final ValueChanged<SettingsPageFactory> onOpenPage;

  const _SettingsMenuList({
    super.key,
    required this.entries,
    required this.onOpenPage,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: kSettingsPagePadding,
      itemCount: entries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final entry = entries[index];

        return SettingsMenuTile(
          icon: entry.icon,
          title: entry.title,
          subtitle: entry.subtitle,
          onTap: () => onOpenPage(entry.pageFactory),
        );
      },
    );
  }
}

class _SettingsSearchResults extends StatelessWidget {
  final String query;
  final List<SettingsSearchEntry> results;
  final ValueChanged<SettingsPageFactory> onOpenPage;
  final String Function(SettingsSearchEntry entry) subtitleBuilder;

  const _SettingsSearchResults({
    super.key,
    required this.query,
    required this.results,
    required this.onOpenPage,
    required this.subtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return SettingsEmptyState(
        icon: Icons.search_off_rounded,
        title: '没有找到相关设置项',
        description: '“$query” 没有匹配到具体设置项，请换个关键词试试。',
      );
    }

    return ListView.separated(
      padding: kSettingsPagePadding,
      itemCount: results.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _SearchResultHeader(count: results.length);
        }

        final entry = results[index - 1];
        return SettingsListItem(
          title: entry.title,
          subtitle: subtitleBuilder(entry),
          onTap: () => onOpenPage(entry.pageFactory),
        );
      },
    );
  }
}

class _SearchResultHeader extends StatelessWidget {
  final int count;

  const _SearchResultHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '找到 $count 个具体设置项',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
