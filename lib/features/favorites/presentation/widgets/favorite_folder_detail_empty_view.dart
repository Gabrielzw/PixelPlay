import 'package:flutter/material.dart';

const double _kFavoriteFolderDetailEmptyIconSize = 40;

class FavoriteFolderDetailEmptyView extends StatelessWidget {
  final String? searchQuery;

  const FavoriteFolderDetailEmptyView({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.video_library_outlined,
              size: _kFavoriteFolderDetailEmptyIconSize,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              _resolveFavoriteFolderEmptyMessage(searchQuery),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _resolveFavoriteFolderEmptyMessage(String? searchQuery) {
  final normalizedQuery = searchQuery?.trim() ?? '';
  if (normalizedQuery.isNotEmpty) {
    return '\u6ca1\u6709\u627e\u5230\u5339\u914d "$normalizedQuery" \u7684\u6536\u85cf\u89c6\u9891';
  }
  return '\u5f53\u524d\u6536\u85cf\u5939\u8fd8\u6ca1\u6709\u89c6\u9891';
}
