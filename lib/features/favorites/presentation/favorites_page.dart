import 'package:flutter/material.dart';

import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import '../../player_core/domain/player_queue_item.dart';
import '../../player_core/presentation/player_page.dart';

@immutable
class FavoriteItem {
  final String title;
  final String source;
  final bool isRemote;

  const FavoriteItem({
    required this.title,
    required this.source,
    required this.isRemote,
  });
}

const List<FavoriteItem> kDemoFavorites = <FavoriteItem>[
  FavoriteItem(title: 'Local_001.mp4', source: '本地 / 相册 1', isRemote: false),
  FavoriteItem(title: 'A.mp4', source: 'WebDAV / Movies', isRemote: true),
  FavoriteItem(title: 'B.mp4', source: 'WebDAV / Anime', isRemote: true),
];

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavoritesScaffold();
  }
}

class _FavoritesScaffold extends StatelessWidget {
  const _FavoritesScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收藏')),
      body: const _FavoritesBody(),
    );
  }
}

class _FavoritesBody extends StatelessWidget {
  const _FavoritesBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const UiSkeletonNotice(message: 'UI 骨架阶段：收藏写入、本地/网络统一索引与排序筛选尚未接入。'),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            key: const PageStorageKey<String>('favorites_list'),
            padding: const EdgeInsets.all(16),
            itemCount: kDemoFavorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = kDemoFavorites[index];
              return _FavoriteTile(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final FavoriteItem item;

  const _FavoriteTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(item.isRemote ? Icons.cloud : Icons.phone_android),
        title: Text(item.title),
        subtitle: Text(item.source),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<void>(
              builder: (_) => PlayerPage(
                playlist: <PlayerQueueItem>[
                  PlayerQueueItem(
                    id: '${item.source}:${item.title}',
                    title: item.title,
                    sourceLabel: item.source,
                    isRemote: item.isRemote,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
