import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/utils/not_implemented.dart';
import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import 'album_page.dart';
import 'controllers/media_library_controller.dart';
import 'widgets/library_album_card.dart';

const double kLibraryPageHorizontalPadding = 22;
const double kLibraryGridSpacing = 18;
const double kLibraryGridChildAspectRatio = 0.92;
const int kAlbumSkeletonCount = 8;
const String kUnnamedAlbumLabel = '未命名相册';
const String kVideoCountSuffix = ' 个视频';

const int kFnvOffsetBasis = 2166136261;
const int kFnvPrime = 16777619;
const int kFnvHashMask = 0xFFFFFFFF;

@immutable
class _AlbumPalette {
  final Color start;
  final Color end;

  const _AlbumPalette({required this.start, required this.end});
}

const List<_AlbumPalette> _kAlbumPalettes = <_AlbumPalette>[
  _AlbumPalette(start: Color(0xFFD6C8D0), end: Color(0xFFA3939B)),
  _AlbumPalette(start: Color(0xFFD9DAD5), end: Color(0xFFA5B0A8)),
  _AlbumPalette(start: Color(0xFFCDBDAF), end: Color(0xFF9C8A7A)),
  _AlbumPalette(start: Color(0xFFD8C6C4), end: Color(0xFFA78682)),
  _AlbumPalette(start: Color(0xFFB8BBC2), end: Color(0xFF747986)),
  _AlbumPalette(start: Color(0xFF8E84D8), end: Color(0xFF4C4086)),
  _AlbumPalette(start: Color(0xFFD8C1B0), end: Color(0xFF9E7767)),
  _AlbumPalette(start: Color(0xFFE0C3CB), end: Color(0xFFB98997)),
];

class LocalLibraryPage extends StatelessWidget {
  const LocalLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);
    final controller = Get.find<MediaLibraryController>();
    final repository = Get.find<MediaLibraryRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text('本地媒体', style: titleStyle),
        actions: <Widget>[
          IconButton(
            tooltip: '搜索',
            onPressed: () => showNotImplementedSnackBar(context, '搜索功能尚未接入'),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: '排序',
            onPressed: () => showNotImplementedSnackBar(context, '排序功能尚未接入'),
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Obx(() {
        final state = controller.state.value;
        return CustomScrollView(
          key: const PageStorageKey<String>('local_album_grid'),
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                kLibraryPageHorizontalPadding,
                12,
                kLibraryPageHorizontalPadding,
                24,
              ),
              sliver: switch (state) {
                MediaLibraryLoadingState() => const _LibraryAlbumSkeletonGrid(),
                MediaLibraryPermissionRequiredState() =>
                  _LibraryPermissionNotice(
                    onGrant: () => controller.requestPermissionAndRefresh(),
                  ),
                MediaLibraryFailureState(:final error) => _LibraryErrorNotice(
                  message: error.toString(),
                  onRetry: () => controller.refreshAlbums(),
                ),
                MediaLibraryReadyState(:final albums) => _LibraryAlbumGrid(
                  albums: albums,
                  repository: repository,
                ),
              },
            ),
          ],
        );
      }),
    );
  }
}

class _LibraryAlbumGrid extends StatelessWidget {
  final List<LocalAlbum> albums;
  final MediaLibraryRepository repository;

  const _LibraryAlbumGrid({required this.albums, required this.repository});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final album = albums[index];
        final title = _resolveAlbumTitle(album.bucketName);
        final palette = _resolveAlbumPalette(album.bucketId);

        return LibraryAlbumCard(
          album: LibraryAlbumPreview(
            title: title,
            subtitle: '${album.videoCount}$kVideoCountSuffix',
            icon: _resolveAlbumIcon(title),
            startColor: palette.start,
            endColor: palette.end,
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => AlbumPage(album: album, repository: repository),
            ),
          ),
        );
      }, childCount: albums.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: kLibraryGridSpacing,
        crossAxisSpacing: kLibraryGridSpacing,
        childAspectRatio: kLibraryGridChildAspectRatio,
      ),
    );
  }
}

class _LibraryAlbumSkeletonGrid extends StatelessWidget {
  const _LibraryAlbumSkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => const _AlbumSkeletonCard(),
        childCount: kAlbumSkeletonCount,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: kLibraryGridSpacing,
        crossAxisSpacing: kLibraryGridSpacing,
        childAspectRatio: kLibraryGridChildAspectRatio,
      ),
    );
  }
}

class _AlbumSkeletonCard extends StatelessWidget {
  const _AlbumSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final fill = Theme.of(context).colorScheme.surfaceContainerHighest;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: const BorderRadius.all(
          Radius.circular(kLibraryAlbumCardRadius),
        ),
      ),
    );
  }
}

class _LibraryPermissionNotice extends StatelessWidget {
  final VoidCallback onGrant;

  const _LibraryPermissionNotice({required this.onGrant});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '需要授予“视频访问权限”才能读取本地相册信息。',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: onGrant, child: const Text('授予权限')),
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryErrorNotice extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LibraryErrorNotice({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('读取相册失败：$message'),
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: const Text('重试')),
            ],
          ),
        ),
      ),
    );
  }
}

String _resolveAlbumTitle(String bucketName) {
  if (bucketName.trim().isEmpty) {
    return kUnnamedAlbumLabel;
  }
  return bucketName;
}

_AlbumPalette _resolveAlbumPalette(String bucketId) {
  final hash = _fnv1aHash(bucketId);
  final index = hash % _kAlbumPalettes.length;
  return _kAlbumPalettes[index];
}

int _fnv1aHash(String value) {
  var hash = kFnvOffsetBasis;
  for (final unit in value.codeUnits) {
    hash ^= unit;
    hash = (hash * kFnvPrime) & kFnvHashMask;
  }
  return hash;
}

IconData _resolveAlbumIcon(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('camera') || lower.contains('dcim')) {
    return Icons.videocam_rounded;
  }
  if (lower.contains('download')) {
    return Icons.download_rounded;
  }
  if (lower.contains('screenshot')) {
    return Icons.photo_library_rounded;
  }
  if (lower.contains('telegram')) {
    return Icons.send_rounded;
  }
  if (lower.contains('weixin') || lower.contains('wechat')) {
    return Icons.chat_bubble_rounded;
  }
  return Icons.folder_rounded;
}
