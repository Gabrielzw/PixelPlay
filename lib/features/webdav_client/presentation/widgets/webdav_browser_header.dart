import 'package:flutter/material.dart';

import '../../domain/webdav_paths.dart';

const double _kSearchBarRadius = 22;
const double _kCurrentCrumbRadius = 14;

class WebDavBreadcrumbBar extends StatelessWidget {
  final String rootPath;
  final String currentPath;
  final ValueChanged<String> onTapPath;

  const WebDavBreadcrumbBar({
    super.key,
    required this.rootPath,
    required this.currentPath,
    required this.onTapPath,
  });

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _HomeCrumb(
            selected: currentPath == rootPath,
            onTap: () => onTapPath(rootPath),
          ),
          for (final item in items) ...<Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_right_rounded, size: 18),
            ),
            _PathCrumb(
              label: item.label,
              selected: item.path == currentPath,
              onTap: () => onTapPath(item.path),
            ),
          ],
        ],
      ),
    );
  }

  List<_BreadCrumbItem> _buildItems() {
    final rootSegments = _segments(rootPath);
    final currentSegments = _segments(currentPath);
    final relativeSegments = currentSegments.skip(rootSegments.length);
    final items = <_BreadCrumbItem>[];
    var path = rootPath;

    for (final segment in relativeSegments) {
      path = _appendSegment(path, segment);
      items.add(_BreadCrumbItem(label: segment, path: path));
    }
    return items;
  }

  List<String> _segments(String path) {
    return normalizeWebDavPath(path)
        .split('/')
        .where((String segment) => segment.isNotEmpty)
        .toList(growable: false);
  }

  String _appendSegment(String basePath, String segment) {
    if (basePath == kWebDavRootPath) {
      return '/$segment';
    }
    return '$basePath/$segment';
  }
}

class WebDavSearchField extends StatelessWidget {
  final TextEditingController controller;

  const WebDavSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: '搜索文件和文件夹...',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_kSearchBarRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _HomeCrumb extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _HomeCrumb({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = selected
        ? colorScheme.primaryContainer
        : Colors.transparent;
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(_kCurrentCrumbRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_kCurrentCrumbRadius),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Icon(Icons.home_filled, size: 18),
        ),
      ),
    );
  }
}

class _PathCrumb extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PathCrumb({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (selected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(_kCurrentCrumbRadius),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_kCurrentCrumbRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _BreadCrumbItem {
  final String label;
  final String path;

  const _BreadCrumbItem({required this.label, required this.path});
}
