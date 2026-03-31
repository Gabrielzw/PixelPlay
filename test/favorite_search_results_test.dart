import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/favorites/presentation/favorite_folder_sort_type.dart';
import 'package:pixelplay/features/favorites/presentation/favorite_models.dart';
import 'package:pixelplay/features/favorites/presentation/widgets/favorite_search_results.dart';

void main() {
  testWidgets('favorite search video tile triggers playback callback', (
    WidgetTester tester,
  ) async {
    FavoriteFolderEntry? tappedFolder;
    FavoriteVideoEntry? tappedVideo;
    final folder = FavoriteFolderEntry(
      id: 'movie-folder',
      title: '电影收藏',
      createdAt: DateTime(2026, 3, 8, 8),
      videos: <FavoriteVideoEntry>[
        FavoriteVideoEntry(
          id: 'travel-vlog',
          title: '旅行Vlog.mp4',
          durationText: '12:40',
          updatedAt: DateTime(2026, 3, 8, 20),
          previewSeed: 2,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteSearchResults(
            query: '旅行',
            folders: <FavoriteFolderEntry>[
              FavoriteFolderEntry(
                id: kDefaultFavoriteFolderId,
                title: kDefaultFavoriteFolderTitle,
                createdAt: DateTime(2025, 1, 1, 8),
                videos: const <FavoriteVideoEntry>[],
              ),
              folder,
            ],
            selectedFolderIds: const <String>{},
            isSelectionMode: false,
            sortType: FavoriteFolderSortType.updatedDesc,
            onFolderTap: (_) {},
            onFolderLongPress: (_) {},
            onVideoTap: (nextFolder, nextVideo) {
              tappedFolder = nextFolder;
              tappedVideo = nextVideo;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('旅行Vlog.mp4'));
    await tester.pumpAndSettle();

    expect(tappedFolder?.id, 'movie-folder');
    expect(tappedVideo?.id, 'travel-vlog');
  });
}
