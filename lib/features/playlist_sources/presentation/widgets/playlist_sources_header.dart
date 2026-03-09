import 'package:flutter/material.dart';

const double kPlaylistHeaderPadding = 16;

class PlaylistSourcesHeader extends StatelessWidget {
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onAddPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onExitSelectionMode;

  const PlaylistSourcesHeader({
    super.key,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onAddPressed,
    required this.onDeletePressed,
    required this.onExitSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kPlaylistHeaderPadding,
        12,
        kPlaylistHeaderPadding,
        12,
      ),
      child: Row(
        children: <Widget>[
          if (isSelectionMode) ...<Widget>[
            Text('已选择 $selectedCount 项'),
            const Spacer(),
            IconButton(
              tooltip: '删除',
              onPressed: onDeletePressed,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
            TextButton(onPressed: onExitSelectionMode, child: const Text('取消')),
          ] else ...<Widget>[
            Tooltip(
              message: '添加播放列表',
              child: FilledButton.tonalIcon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.playlist_add_rounded),
                label: const Text('添加播放列表'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PlaylistEmptyView extends StatelessWidget {
  const PlaylistEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.playlist_remove_outlined,
            size: 42,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            '还没有播放列表',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '可添加本地相册或 WebDAV 目录',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
