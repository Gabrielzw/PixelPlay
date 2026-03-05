import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';
import '../../../shared/widgets/skeleton/skeleton_box.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import '../../player_core/presentation/player_page.dart';

const int kVideoSkeletonCount = 24;
const int kVideoGridCrossAxisCount = 3;
const double kVideoGridSpacing = 10;
const double kVideoTileAspectRatio = 0.62;
const double kVideoThumbAspectRatio = 16 / 9;

class AlbumPage extends StatelessWidget {
  final String albumTitle;

  const AlbumPage({super.key, required this.albumTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(albumTitle),
        actions: <Widget>[
          IconButton(
            tooltip: '搜索',
            onPressed: () => showNotImplementedSnackBar(context, '搜索（未接入）'),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: '排序',
            onPressed: () => showNotImplementedSnackBar(context, '排序（未接入）'),
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: const _AlbumBody(),
    );
  }
}

class _AlbumBody extends StatelessWidget {
  const _AlbumBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const UiSkeletonNotice(message: 'UI 骨架阶段：缩略图、筛选/排序、播放记录与收藏尚未接入。'),
        const SizedBox(height: 12),
        const Expanded(child: _VideoGrid()),
      ],
    );
  }
}

class _VideoGrid extends StatelessWidget {
  const _VideoGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        key: const PageStorageKey<String>('album_video_grid'),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kVideoGridCrossAxisCount,
          mainAxisSpacing: kVideoGridSpacing,
          crossAxisSpacing: kVideoGridSpacing,
          childAspectRatio: kVideoTileAspectRatio,
        ),
        itemCount: kVideoSkeletonCount,
        itemBuilder: (context, index) {
          final title = 'Video_${index + 1}.mp4';

          return _VideoTile(
            title: title,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute<void>(
                  builder: (_) => PlayerPage(title: title),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _VideoTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(kSkeletonRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AspectRatio(
            aspectRatio: kVideoThumbAspectRatio,
            child: SkeletonBox(),
          ),
          const SizedBox(height: 8),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('--:--', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
