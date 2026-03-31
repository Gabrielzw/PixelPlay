import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/features/favorites/data/in_memory_favorites_repository.dart';
import 'package:pixelplay/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:pixelplay/features/favorites/presentation/favorite_models.dart';
import 'package:pixelplay/features/favorites/presentation/favorites_page.dart';
import 'package:pixelplay/features/favorites/presentation/widgets/favorite_folder_card.dart';
import 'package:pixelplay/features/playlist_sources/presentation/playlist_source_models.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';
import 'package:pixelplay/features/webdav_client/domain/webdav_server_config.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );
  });

  tearDown(Get.reset);

  testWidgets('favorites page shows default folder toolbar actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: buildInitialFavoriteFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );

    expect(find.text('\u6536\u85cf'), findsOneWidget);
    expect(find.text('\u6536\u85cf\u5939'), findsOneWidget);
    expect(find.text('\u64ad\u653e\u5217\u8868'), findsOneWidget);
    expect(find.text('\u9ed8\u8ba4\u6536\u85cf\u5939'), findsOneWidget);
    expect(find.text('0 \u4e2a\u89c6\u9891'), findsOneWidget);
    expect(find.byTooltip('\u6dfb\u52a0\u6536\u85cf\u5939'), findsOneWidget);
    expect(find.byTooltip('\u641c\u7d22'), findsOneWidget);
    expect(find.byTooltip('\u6392\u5e8f'), findsOneWidget);
  });

  testWidgets('favorites page creates folder in secondary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: buildInitialFavoriteFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );

    await tester.tap(find.byTooltip('\u6dfb\u52a0\u6536\u85cf\u5939'));
    await tester.pumpAndSettle();

    expect(find.text('\u65b0\u5efa\u6536\u85cf\u5939'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField),
      '\u7535\u5f71\u6536\u85cf',
    );
    await tester.tap(find.text('\u521b\u5efa'));
    await tester.pumpAndSettle();

    expect(find.text('\u7535\u5f71\u6536\u85cf'), findsOneWidget);
  });

  testWidgets('favorites search matches folders and videos together', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: _buildSearchFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );

    await tester.tap(find.byTooltip('\u641c\u7d22'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '\u65c5\u884c');
    await tester.pumpAndSettle();

    expect(find.text('\u6536\u85cf\u5939'), findsNWidgets(2));
    expect(find.text('\u89c6\u9891'), findsOneWidget);
    expect(find.text('\u65c5\u884c\u6536\u85cf'), findsOneWidget);
    expect(find.text('\u65c5\u884cVlog.mp4'), findsOneWidget);
    expect(
      find.text('\u6536\u85cf\u5939 \u00b7 \u7535\u5f71\u6536\u85cf'),
      findsOneWidget,
    );
  });

  testWidgets('default folder is not pinned in search results', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: _buildSearchFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );

    await tester.tap(find.byTooltip('\u641c\u7d22'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '\u6536\u85cf');
    await tester.pumpAndSettle();

    expect(_folderTitles(tester), <String>[
      '\u7535\u5f71\u6536\u85cf',
      '\u65c5\u884c\u6536\u85cf',
      '\u9ed8\u8ba4\u6536\u85cf\u5939',
    ]);
  });

  testWidgets('favorites sort orders folders by name asc', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: _buildSortFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(_folderTitles(tester), <String>[
      '\u9ed8\u8ba4\u6536\u85cf\u5939',
      'Gamma',
      'Alpha',
      'Beta',
    ]);

    await tester.tap(find.byTooltip('\u6392\u5e8f'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u540d\u79f0 A-Z').last);
    await tester.pumpAndSettle();

    expect(_folderTitles(tester), <String>[
      'Alpha',
      'Beta',
      'Gamma',
      '\u9ed8\u8ba4\u6536\u85cf\u5939',
    ]);
  });

  testWidgets('favorites page enters selection mode after long press', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: _buildSortFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );

    await tester.longPress(find.text('Gamma'));
    await tester.pumpAndSettle();

    expect(find.text('\u5df2\u9009\u62e9 1 \u9879'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();

    expect(find.text('\u5df2\u9009\u62e9 2 \u9879'), findsOneWidget);
  });

  testWidgets('favorites page confirms before deleting selected folders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: _buildSortFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );

    await tester.longPress(find.text('Gamma'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('\u5220\u9664'));
    await tester.pumpAndSettle();

    expect(find.text('\u5220\u9664\u6536\u85cf\u5939'), findsOneWidget);
    expect(
      find.text(
        '\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684 1 \u4e2a\u6536\u85cf\u5939\u5417\uff1f',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('\u5220\u9664'));
    await tester.pumpAndSettle();

    expect(find.text('Gamma'), findsNothing);
  });

  testWidgets('favorite folder detail edits folder name from more menu', (
    WidgetTester tester,
  ) async {
    final favoritesController = FavoritesController(
      repository: InMemoryFavoritesRepository(
        initialFolders: _buildSortFolders(),
      ),
    );
    favoritesController.refreshFolders();

    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          favoritesController: favoritesController,
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gamma'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('\u66f4\u591a'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u7f16\u8f91\u4fe1\u606f'));
    await tester.pumpAndSettle();

    expect(find.text('\u7f16\u8f91\u6536\u85cf\u5939'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Gamma Prime');
    await tester.tap(find.text('\u4fdd\u5b58'));
    await tester.pumpAndSettle();

    expect(find.text('Gamma Prime'), findsOneWidget);

    await tester.tap(find.byTooltip('\u8fd4\u56de'));
    await tester.pumpAndSettle();

    expect(find.text('Gamma Prime'), findsOneWidget);
    expect(
      favoritesController.folderById('gamma-folder')?.title,
      'Gamma Prime',
    );
  });

  testWidgets('default folder cannot enter selection mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: _buildSortFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );

    await tester.longPress(find.text(kDefaultFavoriteFolderTitle));
    await tester.pumpAndSettle();

    expect(find.text('\u5df2\u9009\u62e9 1 \u9879'), findsNothing);
    expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
    expect(find.text(kDefaultFavoriteFolderTitle), findsOneWidget);
  });
  testWidgets('favorites page shows playlist tab entries', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: buildInitialFavoriteFolders(),
          initialPlaylistSources: <PlaylistSourceEntry>[
            PlaylistSourceEntry.webDavDirectory(
              account: _buildPlaylistTestAccount(),
              path: '/电影',
              createdAt: DateTime(2026, 3, 9, 12),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('\u64ad\u653e\u5217\u8868'));
    await tester.pumpAndSettle();

    expect(find.text('\u7535\u5f71'), findsOneWidget);
    expect(find.text('WebDAV \u00b7 \u5bb6\u91cc\u4e91\u76d8'), findsOneWidget);
    expect(find.text('/\u7535\u5f71'), findsOneWidget);
    expect(
      find.byTooltip('\u6dfb\u52a0\u64ad\u653e\u5217\u8868'),
      findsOneWidget,
    );
  });
}

List<String> _folderTitles(WidgetTester tester) {
  return tester
      .widgetList<FavoriteFolderCard>(find.byType(FavoriteFolderCard))
      .map((FavoriteFolderCard card) => card.data.title)
      .toList(growable: false);
}

WebDavServerConfig _buildPlaylistTestAccount() {
  return WebDavServerConfig(
    id: 'webdav-home',
    alias: '家里云盘',
    url: Uri.parse('https://example.com/dav/'),
    username: 'tester',
    rootPath: '/',
  );
}

List<FavoriteFolderEntry> _buildSearchFolders() {
  return <FavoriteFolderEntry>[
    FavoriteFolderEntry(
      id: kDefaultFavoriteFolderId,
      title: kDefaultFavoriteFolderTitle,
      createdAt: DateTime(2025, 1, 1, 8),
      videos: const <FavoriteVideoEntry>[],
    ),
    FavoriteFolderEntry(
      id: 'travel-folder',
      title: '\u65c5\u884c\u6536\u85cf',
      createdAt: DateTime(2026, 3, 7, 9),
      videos: <FavoriteVideoEntry>[
        FavoriteVideoEntry(
          id: 'travel-sunset',
          title: '\u6d77\u8fb9\u65e5\u843d.mp4',
          durationText: '08:16',
          updatedAt: DateTime(2026, 3, 7, 10),
          previewSeed: 1,
        ),
      ],
    ),
    FavoriteFolderEntry(
      id: 'movie-folder',
      title: '\u7535\u5f71\u6536\u85cf',
      createdAt: DateTime(2026, 3, 8, 8),
      videos: <FavoriteVideoEntry>[
        FavoriteVideoEntry(
          id: 'travel-vlog',
          title: '\u65c5\u884cVlog.mp4',
          durationText: '12:40',
          updatedAt: DateTime(2026, 3, 8, 20),
          previewSeed: 2,
        ),
      ],
    ),
  ];
}

List<FavoriteFolderEntry> _buildSortFolders() {
  return <FavoriteFolderEntry>[
    FavoriteFolderEntry(
      id: kDefaultFavoriteFolderId,
      title: kDefaultFavoriteFolderTitle,
      createdAt: DateTime(2025, 1, 1, 8),
      videos: const <FavoriteVideoEntry>[],
    ),
    FavoriteFolderEntry(
      id: 'gamma-folder',
      title: 'Gamma',
      createdAt: DateTime(2026, 3, 9, 8),
      videos: const <FavoriteVideoEntry>[],
    ),
    FavoriteFolderEntry(
      id: 'alpha-folder',
      title: 'Alpha',
      createdAt: DateTime(2026, 3, 8, 8),
      videos: const <FavoriteVideoEntry>[],
    ),
    FavoriteFolderEntry(
      id: 'beta-folder',
      title: 'Beta',
      createdAt: DateTime(2026, 3, 7, 8),
      videos: const <FavoriteVideoEntry>[],
    ),
  ];
}
