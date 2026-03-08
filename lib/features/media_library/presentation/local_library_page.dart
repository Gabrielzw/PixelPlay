import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import '../domain/entities/local_video.dart';
import 'album_page.dart';
import 'controllers/media_library_controller.dart';
import 'local_library_album_preview_builder.dart';
import 'local_library_sort_type.dart';
import 'widgets/library_album_card.dart';
import 'widgets/local_library_app_bar.dart';
import 'widgets/local_library_search_results.dart';
import '../../watch_history/presentation/watch_history_page.dart';

const double kLibraryPageHorizontalPadding = 22;
const double kLibraryGridSpacing = 18;
const double kLibraryGridChildAspectRatio = 0.92;
const int kAlbumSkeletonCount = 8;

class LocalLibraryPage extends StatefulWidget {
  const LocalLibraryPage({super.key});

  @override
  State<LocalLibraryPage> createState() => _LocalLibraryPageState();
}

class _LocalLibraryPageState extends State<LocalLibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  var _isSearching = false;
  var _searchQuery = '';
  var _sortType = LocalLibrarySortType.latest;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MediaLibraryController>();
    final repository = Get.find<MediaLibraryRepository>();

    return Scaffold(
      appBar: LocalLibraryAppBar(
        title: 'Pixel Play',
        isSearching: _isSearching,
        searchController: _searchController,
        currentSort: _sortType,
        onSearchChanged: _updateSearchQuery,
        onStartSearching: _startSearching,
        onStopSearching: _stopSearching,
        onSortSelected: _updateSortType,
        onOpenHistory: _openWatchHistory,
      ),
      body: Obx(
        () => _buildBody(controller: controller, repository: repository),
      ),
    );
  }

  Widget _buildBody({
    required MediaLibraryController controller,
    required MediaLibraryRepository repository,
  }) {
    final state = controller.state.value;

    return switch (state) {
      MediaLibraryLoadingState() => _buildSliverBody(
        sliver: const _LibraryAlbumSkeletonGrid(),
      ),
      MediaLibraryPermissionRequiredState() => _buildSliverBody(
        sliver: _LibraryPermissionNotice(
          onGrant: controller.requestPermissionAndRefresh,
        ),
      ),
      MediaLibraryFailureState(:final error) => _buildSliverBody(
        sliver: _LibraryErrorNotice(
          message: error.toString(),
          onRetry: controller.refreshAlbums,
        ),
      ),
      MediaLibraryReadyState(:final albums) => _buildReadyBody(
        albums: albums,
        controller: controller,
        repository: repository,
      ),
    };
  }

  Widget _buildReadyBody({
    required List<LocalAlbum> albums,
    required MediaLibraryController controller,
    required MediaLibraryRepository repository,
  }) {
    final sortedAlbums = sortLocalAlbums(albums, _sortType);
    final normalizedQuery = _searchQuery.trim();

    if (normalizedQuery.isEmpty) {
      return _buildSliverBody(
        sliver: _LibraryAlbumGrid(albums: sortedAlbums, repository: repository),
      );
    }

    return FutureBuilder<List<LocalVideo>>(
      future: controller.loadSearchableVideos(albums),
      builder:
          (BuildContext context, AsyncSnapshot<List<LocalVideo>> snapshot) {
            return LocalLibrarySearchResults(
              query: normalizedQuery,
              albums: sortedAlbums,
              videos: snapshot.data,
              videoLoadingError: snapshot.hasError ? snapshot.error : null,
              isLoadingVideos:
                  snapshot.connectionState != ConnectionState.done &&
                  !snapshot.hasError,
              sortType: _sortType,
              repository: repository,
            );
          },
    );
  }

  Widget _buildSliverBody({required Widget sliver}) {
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
          sliver: sliver,
        ),
      ],
    );
  }

  void _startSearching() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
    });
  }

  void _updateSearchQuery(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _updateSortType(LocalLibrarySortType value) {
    setState(() {
      _sortType = value;
    });
  }

  Future<void> _openWatchHistory() {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const WatchHistoryPage()));
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
              Text('需要授予“视频访问权限”后才能读取本地相册信息。'),
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
