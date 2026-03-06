import 'package:flutter/material.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../domain/entities/webdav_entry.dart';

const double _kEntryCardRadius = 24;
const double _kEntryIconSize = 56;
const double _kEntryIconRadius = 18;
const int _kEntryTitleMaxLines = 2;

class WebDavEntryCard extends StatelessWidget {
  final WebDavEntry entry;
  final VoidCallback onTap;

  const WebDavEntryCard({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(_kEntryCardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_kEntryCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              _EntryTypeAvatar(type: entry.type),
              const SizedBox(width: 14),
              Expanded(child: _EntryText(entry: entry)),
              if (entry.type == WebDavEntryType.directory ||
                  entry.type == WebDavEntryType.video)
                const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class WebDavBrowserFailureView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const WebDavBrowserFailureView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_outlined, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('重新加载')),
          ],
        ),
      ),
    );
  }
}

class WebDavBrowserEmptyView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRefresh;

  const WebDavBrowserEmptyView({
    super.key,
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SizedBox(height: 120),
          const Icon(Icons.folder_open_outlined, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _EntryTypeAvatar extends StatelessWidget {
  final WebDavEntryType type;

  const _EntryTypeAvatar({required this.type});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: _kEntryIconSize,
      height: _kEntryIconSize,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(_kEntryIconRadius),
      ),
      child: Icon(_resolveIcon(), color: colorScheme.onSecondaryContainer),
    );
  }

  IconData _resolveIcon() {
    return switch (type) {
      WebDavEntryType.directory => Icons.folder_copy_rounded,
      WebDavEntryType.video => Icons.movie_creation_outlined,
      WebDavEntryType.other => Icons.insert_drive_file_outlined,
    };
  }
}

class _EntryText extends StatelessWidget {
  final WebDavEntry entry;

  const _EntryText({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          entry.name,
          maxLines: _kEntryTitleMaxLines,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          _buildSubtitle(entry),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  String _buildSubtitle(WebDavEntry entry) {
    final parts = <String>[];
    if (entry.type == WebDavEntryType.video && entry.size > 0) {
      parts.add(formatFileSize(entry.size));
    }
    if (entry.modifiedAt != null) {
      parts.add(_formatDateTime(entry.modifiedAt!));
    }
    if (parts.isEmpty) {
      return entry.type == WebDavEntryType.directory ? '文件夹' : '视频文件';
    }
    return parts.join(' · ');
  }

  String _formatDateTime(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '${value.year}-$month-$day $hour:$minute:$second';
  }
}
