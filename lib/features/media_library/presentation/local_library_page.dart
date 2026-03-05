import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';
import '../../../shared/widgets/skeleton/skeleton_box.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import 'album_page.dart';

const int kAlbumSkeletonCount = 12;
const int kAlbumGridCrossAxisCount = 2;
const double kAlbumGridSpacing = 12;
const double kAlbumCardAspectRatio = 0.95;
const double kAlbumCoverAspectRatio = 16 / 9;

class LocalLibraryPage extends StatelessWidget {
  const LocalLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LocalLibraryScaffold();
  }
}

class _LocalLibraryScaffold extends StatelessWidget {
  const _LocalLibraryScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('本地媒体'),
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
      body: const _LocalLibraryBody(),
    );
  }
}

class _LocalLibraryBody extends StatelessWidget {
  const _LocalLibraryBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const UiSkeletonNotice(
          message: 'UI 骨架阶段：MediaStore 扫描、Isar 落库、缩略图提取尚未接入。',
        ),
        const SizedBox(height: 12),
        const Expanded(child: _AlbumGrid()),
      ],
    );
  }
}

class _AlbumGrid extends StatelessWidget {
  const _AlbumGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        key: const PageStorageKey<String>('local_album_grid'),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kAlbumGridCrossAxisCount,
          mainAxisSpacing: kAlbumGridSpacing,
          crossAxisSpacing: kAlbumGridSpacing,
          childAspectRatio: kAlbumCardAspectRatio,
        ),
        itemCount: kAlbumSkeletonCount,
        itemBuilder: (context, index) {
          final title = '相册 ${index + 1}';

          return _AlbumTile(
            title: title,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AlbumPage(albumTitle: title),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _AlbumTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const AspectRatio(
                aspectRatio: kAlbumCoverAspectRatio,
                child: SkeletonBox(),
              ),
              const SizedBox(height: 12),
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('待扫描', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
