import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';
import 'album_page.dart';
import 'widgets/library_album_card.dart';

const double kLibraryPageHorizontalPadding = 22;
const double kLibraryGridSpacing = 18;
const double kLibraryGridChildAspectRatio = 0.92;

const List<LibraryAlbumPreview> kPreviewAlbums = <LibraryAlbumPreview>[
  LibraryAlbumPreview(
    title: 'Screenshots',
    subtitle: '4 个视频',
    icon: Icons.photo_library_rounded,
    startColor: Color(0xFFD6C8D0),
    endColor: Color(0xFFA3939B),
  ),
  LibraryAlbumPreview(
    title: 'Camera',
    subtitle: '405 个视频',
    icon: Icons.videocam_rounded,
    startColor: Color(0xFFD9DAD5),
    endColor: Color(0xFFA5B0A8),
  ),
  LibraryAlbumPreview(
    title: 'Download',
    subtitle: '6 个视频',
    icon: Icons.download_rounded,
    startColor: Color(0xFFCDBDAF),
    endColor: Color(0xFF9C8A7A),
  ),
  LibraryAlbumPreview(
    title: 'Telegram',
    subtitle: '1 个视频',
    icon: Icons.send_rounded,
    startColor: Color(0xFFD8C6C4),
    endColor: Color(0xFFA78682),
  ),
  LibraryAlbumPreview(
    title: 'WeiXin',
    subtitle: '6 个视频',
    icon: Icons.chat_bubble_rounded,
    startColor: Color(0xFFB8BBC2),
    endColor: Color(0xFF747986),
  ),
  LibraryAlbumPreview(
    title: 'Games',
    subtitle: '1 个视频',
    icon: Icons.sports_esports_rounded,
    startColor: Color(0xFF8E84D8),
    endColor: Color(0xFF4C4086),
  ),
  LibraryAlbumPreview(
    title: 'Clips',
    subtitle: '12 个视频',
    icon: Icons.movie_creation_rounded,
    startColor: Color(0xFFD8C1B0),
    endColor: Color(0xFF9E7767),
  ),
  LibraryAlbumPreview(
    title: 'Favorites',
    subtitle: '3 个视频',
    icon: Icons.favorite_rounded,
    startColor: Color(0xFFE0C3CB),
    endColor: Color(0xFFB98997),
  ),
];

class LocalLibraryPage extends StatelessWidget {
  const LocalLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Play', style: titleStyle),
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
      body: const CustomScrollView(
        key: PageStorageKey<String>('local_album_grid'),
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              kLibraryPageHorizontalPadding,
              12,
              kLibraryPageHorizontalPadding,
              24,
            ),
            sliver: _LibraryAlbumGrid(),
          ),
        ],
      ),
    );
  }
}

class _LibraryAlbumGrid extends StatelessWidget {
  const _LibraryAlbumGrid();

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final album = kPreviewAlbums[index];

        return LibraryAlbumCard(
          album: album,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => AlbumPage(albumTitle: album.title),
            ),
          ),
        );
      }, childCount: kPreviewAlbums.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: kLibraryGridSpacing,
        crossAxisSpacing: kLibraryGridSpacing,
        childAspectRatio: kLibraryGridChildAspectRatio,
      ),
    );
  }
}
