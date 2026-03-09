import 'package:flutter/material.dart';

import '../playlist_source_models.dart';

class PlaylistSourceCard extends StatelessWidget {
  final PlaylistSourceEntry entry;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PlaylistSourceCard({
    super.key,
    required this.entry,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isSelected
        ? colorScheme.primary
        : colorScheme.outlineVariant;
    final backgroundColor = isSelected
        ? colorScheme.primaryContainer.withValues(alpha: 0.35)
        : colorScheme.surfaceContainerLow;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              _PlaylistSourceAvatar(sourceKind: entry.sourceKind),
              const SizedBox(width: 14),
              Expanded(
                child: _PlaylistSourceText(
                  title: entry.title,
                  subtitle: entry.subtitle,
                  detailText: entry.detailText,
                ),
              ),
              if (!isSelectionMode)
                const Icon(Icons.chevron_right_rounded)
              else if (isSelected)
                Icon(Icons.check_circle, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaylistSourceAvatar extends StatelessWidget {
  final PlaylistSourceKind sourceKind;

  const _PlaylistSourceAvatar({required this.sourceKind});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(switch (sourceKind) {
        PlaylistSourceKind.localAlbum => Icons.photo_library_outlined,
        PlaylistSourceKind.webDavDirectory => Icons.folder_copy_outlined,
      }, color: colorScheme.onSecondaryContainer),
    );
  }
}

class _PlaylistSourceText extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? detailText;

  const _PlaylistSourceText({
    required this.title,
    required this.subtitle,
    required this.detailText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        if (detailText != null && detailText!.trim().isNotEmpty) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            detailText!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
