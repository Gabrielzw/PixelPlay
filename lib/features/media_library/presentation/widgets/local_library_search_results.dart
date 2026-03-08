import 'package:flutter/material.dart';

import '../../domain/contracts/media_library_repository.dart';
import '../../domain/entities/local_album.dart';
import '../../domain/entities/local_video.dart';
import '../album_page.dart';
import '../local_library_album_preview_builder.dart';
import '../local_library_sort_type.dart';
import 'library_album_card.dart';
import 'local_library_search_video_tile.dart';

const double kSearchSectionSpacing = 24;

class LocalLibrarySearchResults extends StatelessWidget {
  final String query;
  final List<LocalAlbum> albums;
  final List<LocalVideo>? videos;
  final Object? videoLoadingError;
  final bool isLoadingVideos;
  final LocalLibrarySortType sortType;
  final MediaLibraryRepository repository;

  const LocalLibrarySearchResults({
    super.key,
    required this.query,
    required this.albums,
    required this.videos,
    required this.videoLoadingError,
    required this.isLoadingVideos,
    required this.sortType,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final albumById = <String, LocalAlbum>{
      for (final LocalAlbum album in albums) album.bucketId: album,
    };
    final matchedAlbums = _buildMatchedAlbums(normalizedQuery);
    final matchedVideos = _buildMatchedVideos(normalizedQuery);

    return CustomScrollView(
      key: const PageStorageKey<String>('local_library_search_results'),
      slivers: <Widget>[
        if (matchedAlbums.isNotEmpty) ...<Widget>[
          const _SectionHeader(title: '相册'),
          _AlbumResultGrid(albums: matchedAlbums, repository: repository),
        ],
        if (isLoadingVideos)
          const _InfoSection(title: '视频', child: CircularProgressIndicator())
        else if (videoLoadingError != null)
          _InfoSection(title: '视频', child: Text(videoLoadingError.toString()))
        else if (matchedVideos.isNotEmpty) ...<Widget>[
          const _SectionHeader(title: '视频'),
          _VideoResultList(
            videos: matchedVideos,
            albumById: albumById,
            repository: repository,
          ),
        ],
        if (_showEmptyState(
          matchedAlbums: matchedAlbums,
          matchedVideos: matchedVideos,
        ))
          _EmptySection(query: query),
      ],
    );
  }

  List<LocalAlbum> _buildMatchedAlbums(String normalizedQuery) {
    return sortLocalAlbums(
      albums.where(
        (LocalAlbum album) => _matchesQuery(
          source: resolveLocalLibraryAlbumTitle(album.bucketName),
          normalizedQuery: normalizedQuery,
        ),
      ),
      sortType,
    );
  }

  List<LocalVideo> _buildMatchedVideos(String normalizedQuery) {
    final loadedVideos = videos;
    if (loadedVideos == null) {
      return const <LocalVideo>[];
    }

    return sortLocalVideos(
      loadedVideos.where(
        (LocalVideo video) => _matchesQuery(
          source: video.title,
          normalizedQuery: normalizedQuery,
        ),
      ),
      sortType,
    );
  }

  bool _showEmptyState({
    required List<LocalAlbum> matchedAlbums,
    required List<LocalVideo> matchedVideos,
  }) {
    return !isLoadingVideos &&
        videoLoadingError == null &&
        matchedAlbums.isEmpty &&
        matchedVideos.isEmpty;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Center(child: child),
          ],
        ),
      ),
    );
  }
}

class _AlbumResultGrid extends StatelessWidget {
  final List<LocalAlbum> albums;
  final MediaLibraryRepository repository;

  const _AlbumResultGrid({required this.albums, required this.repository});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, kSearchSectionSpacing),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final album = albums[index];
          return LibraryAlbumCard(
            album: buildLibraryAlbumPreview(album),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AlbumPage(album: album, repository: repository),
              ),
            ),
          );
        }, childCount: albums.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.92,
        ),
      ),
    );
  }
}

class _VideoResultList extends StatelessWidget {
  final List<LocalVideo> videos;
  final Map<String, LocalAlbum> albumById;
  final MediaLibraryRepository repository;

  const _VideoResultList({
    required this.videos,
    required this.albumById,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
      sliver: SliverList.separated(
        itemBuilder: (BuildContext context, int index) {
          final video = videos[index];
          final album = albumById[video.bucketId];
          if (album == null) {
            throw StateError('Missing album for video ${video.id}.');
          }

          return LocalLibrarySearchVideoTile(
            video: video,
            albumTitle: resolveLocalLibraryAlbumTitle(album.bucketName),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AlbumPage(album: album, repository: repository),
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: kSearchVideoTileSpacing),
        itemCount: videos.length,
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String query;

  const _EmptySection({required this.query});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '没有找到和“$query”相关的相册或视频。',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

bool _matchesQuery({required String source, required String normalizedQuery}) {
  if (normalizedQuery.isEmpty) {
    return true;
  }
  return source.toLowerCase().contains(normalizedQuery);
}
