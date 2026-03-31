import 'package:flutter/material.dart';

import '../../domain/entities/webdav_entry.dart';
import 'webdav_browser_entry_widgets.dart';

class WebDavFileList extends StatelessWidget {
  final String storageKey;
  final List<WebDavEntry> entries;
  final ValueChanged<WebDavEntry> onEntryTap;
  final Future<void> Function() onRefresh;

  const WebDavFileList({
    super.key,
    required this.storageKey,
    required this.entries,
    required this.onEntryTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        key: PageStorageKey<String>('webdav_browser_$storageKey'),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: entries.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (BuildContext context, int index) {
          final entry = entries[index];
          return WebDavEntryCard(entry: entry, onTap: () => onEntryTap(entry));
        },
      ),
    );
  }
}
