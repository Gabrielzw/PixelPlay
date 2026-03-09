import 'package:flutter/material.dart';

import '../favorite_folder_sort_type.dart';
import '../favorite_models.dart';
import 'favorite_folder_card.dart';
import 'favorite_search_video_tile.dart';

const double _kSearchSectionSpacing = 24;
const double _kSearchSectionInnerSpacing = 10;
const double _kSearchHorizontalPadding = 16;
const double _kSearchEmptyIconSize = 42;

class FavoriteSearchResults extends StatelessWidget {
  final String query;
  final List<FavoriteFolderEntry> folders;
  final Set<String> selectedFolderIds;
  final bool isSelectionMode;
  final FavoriteFolderSortType sortType;
  final ValueChanged<String> onFolderTap;
  final ValueChanged<String> onFolderLongPress;
  final void Function(FavoriteFolderEntry folder, FavoriteVideoEntry video)
  onVideoTap;

  const FavoriteSearchResults({
    super.key,
    required this.query,
    required this.folders,
    required this.selectedFolderIds,
    required this.isSelectionMode,
    required this.sortType,
    required this.onFolderTap,
    required this.onFolderLongPress,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final matchedFolders = _buildMatchedFolders(normalizedQuery);
    final matchedVideos = _buildMatchedVideos(normalizedQuery);

    return CustomScrollView(
      key: const PageStorageKey<String>('favorite_search_results'),
      slivers: <Widget>[
        if (matchedFolders.isNotEmpty)
          _Section(
            title: '\u6536\u85cf\u5939',
            child: Column(
              children: matchedFolders
                  .map(
                    (FavoriteFolderEntry folder) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: _kSearchSectionInnerSpacing,
                      ),
                      child: FavoriteFolderCard(
                        data: FavoriteFolderCardData(
                          id: folder.id,
                          title: folder.title,
                          videoCount: folder.videoCount,
                          updatedAt: folder.updatedAt,
                          previewSeed: folder.latestVideo?.previewSeed ?? 1,
                          latestThumbnailRequest:
                              folder.latestVideo?.thumbnailRequest,
                        ),
                        isSelectionMode: isSelectionMode,
                        isSelected: selectedFolderIds.contains(folder.id),
                        onTap: () => onFolderTap(folder.id),
                        onLongPress: () => onFolderLongPress(folder.id),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        if (matchedVideos.isNotEmpty)
          _Section(
            title: '\u89c6\u9891',
            child: Column(
              children: matchedVideos
                  .map(
                    (_FavoriteMatchedVideo item) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: _kSearchSectionInnerSpacing,
                      ),
                      child: FavoriteSearchVideoTile(
                        video: item.video,
                        folderTitle: item.folder.title,
                        onTap: isSelectionMode
                            ? null
                            : () => onVideoTap(item.folder, item.video),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        if (matchedFolders.isEmpty && matchedVideos.isEmpty)
          const _EmptySection(),
      ],
    );
  }

  List<FavoriteFolderEntry> _buildMatchedFolders(String normalizedQuery) {
    final matchedFolders = folders
        .where(
          (FavoriteFolderEntry folder) => _matchesQuery(
            source: folder.title,
            normalizedQuery: normalizedQuery,
          ),
        )
        .toList(growable: false);
    matchedFolders.sort(
      (left, right) => _compareFolders(left, right, sortType),
    );
    return matchedFolders;
  }

  List<_FavoriteMatchedVideo> _buildMatchedVideos(String normalizedQuery) {
    final matchedVideos = folders
        .expand(
          (FavoriteFolderEntry folder) => folder.videos
              .where(
                (FavoriteVideoEntry video) => _matchesQuery(
                  source: video.title,
                  normalizedQuery: normalizedQuery,
                ),
              )
              .map(
                (FavoriteVideoEntry video) =>
                    _FavoriteMatchedVideo(video: video, folder: folder),
              ),
        )
        .toList(growable: false);
    matchedVideos.sort(
      (_FavoriteMatchedVideo left, _FavoriteMatchedVideo right) =>
          _compareVideos(left.video, right.video, sortType),
    );
    return matchedVideos;
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _kSearchHorizontalPadding,
          12,
          _kSearchHorizontalPadding,
          _kSearchSectionSpacing,
        ),
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
            child,
          ],
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search_off_rounded,
              size: _kSearchEmptyIconSize,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              '\u6ca1\u6709\u627e\u5230\u5339\u914d\u7684\u6536\u85cf\u5939\u6216\u89c6\u9891',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteMatchedVideo {
  final FavoriteVideoEntry video;
  final FavoriteFolderEntry folder;

  const _FavoriteMatchedVideo({required this.video, required this.folder});
}

int _compareFolders(
  FavoriteFolderEntry left,
  FavoriteFolderEntry right,
  FavoriteFolderSortType sortType,
) {
  return switch (sortType) {
    FavoriteFolderSortType.updatedDesc => right.updatedAt.compareTo(
      left.updatedAt,
    ),
    FavoriteFolderSortType.updatedAsc => left.updatedAt.compareTo(
      right.updatedAt,
    ),
    FavoriteFolderSortType.countDesc => right.videoCount.compareTo(
      left.videoCount,
    ),
    FavoriteFolderSortType.countAsc => left.videoCount.compareTo(
      right.videoCount,
    ),
    FavoriteFolderSortType.nameAsc => left.title.compareTo(right.title),
    FavoriteFolderSortType.nameDesc => right.title.compareTo(left.title),
  };
}

int _compareVideos(
  FavoriteVideoEntry left,
  FavoriteVideoEntry right,
  FavoriteFolderSortType sortType,
) {
  return switch (sortType) {
    FavoriteFolderSortType.updatedDesc => right.updatedAt.compareTo(
      left.updatedAt,
    ),
    FavoriteFolderSortType.updatedAsc => left.updatedAt.compareTo(
      right.updatedAt,
    ),
    FavoriteFolderSortType.nameAsc => left.title.compareTo(right.title),
    FavoriteFolderSortType.nameDesc => right.title.compareTo(left.title),
    FavoriteFolderSortType.countDesc => right.updatedAt.compareTo(
      left.updatedAt,
    ),
    FavoriteFolderSortType.countAsc => left.updatedAt.compareTo(
      right.updatedAt,
    ),
  };
}

bool _matchesQuery({required String source, required String normalizedQuery}) {
  return source.trim().toLowerCase().contains(normalizedQuery);
}
