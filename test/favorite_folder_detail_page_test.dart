import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/features/favorites/presentation/favorite_folder_detail_page.dart';
import 'package:pixelplay/features/favorites/presentation/favorite_models.dart';
import 'package:pixelplay/features/favorites/presentation/favorites_page.dart';
import 'package:pixelplay/features/favorites/presentation/widgets/favorite_folder_preview.dart';
import 'package:pixelplay/features/favorites/presentation/widgets/favorite_folder_video_tile.dart';
import 'package:pixelplay/features/playlist_sources/presentation/playlist_source_models.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put<SettingsController>(
      SettingsController(repository: InMemorySettingsRepository()),
    );
  });

  tearDown(Get.reset);

  testWidgets('tapping folder opens detail page with hero header and toolbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoritesPage(
          initialFolders: _buildDetailFolders(),
          initialPlaylistSources: const <PlaylistSourceEntry>[],
        ),
      ),
    );

    await tester.tap(find.text('\u65c5\u884c\u6536\u85cf'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.byTooltip('\u8fd4\u56de'), findsOneWidget);
    expect(find.byTooltip('\u641c\u7d22'), findsOneWidget);
    expect(find.byTooltip('\u6392\u5e8f'), findsOneWidget);
    expect(find.byTooltip('\u66f4\u591a'), findsOneWidget);
    expect(find.text('\u65c5\u884c\u6536\u85cf'), findsOneWidget);
    expect(find.text('3 \u4e2a\u89c6\u9891'), findsOneWidget);
    expect(find.text('Travel Vlog.mp4'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Hero &&
            widget.tag == buildFavoriteFolderPreviewHeroTag('travel-folder'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('detail page supports long press multi selection', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoriteFolderDetailPage(folder: _buildDetailFolders()[1]),
      ),
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Travel Vlog.mp4'));
    await tester.pumpAndSettle();

    expect(find.text('\u5df2\u9009\u62e9 1 \u9879'), findsOneWidget);
    expect(find.byTooltip('\u53d6\u6d88\u9009\u62e9'), findsOneWidget);

    await tester.tap(find.text('Beach Sunset.mp4'));
    await tester.pumpAndSettle();

    expect(find.text('\u5df2\u9009\u62e9 2 \u9879'), findsOneWidget);
  });

  testWidgets('detail page searches videos in folder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoriteFolderDetailPage(folder: _buildDetailFolders()[1]),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('\u641c\u7d22'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Beach');
    await tester.pumpAndSettle();

    expect(find.text('Beach Sunset.mp4'), findsOneWidget);
    expect(find.text('Travel Vlog.mp4'), findsNothing);
    expect(find.text('Campfire.mp4'), findsNothing);
  });

  testWidgets('detail page sorts videos by name ascending', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoriteFolderDetailPage(folder: _buildDetailFolders()[1]),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('\u6392\u5e8f'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u540d\u79f0 A-Z').last);
    await tester.pumpAndSettle();

    final titles = tester
        .widgetList<FavoriteFolderVideoTile>(
          find.byType(FavoriteFolderVideoTile),
        )
        .map((FavoriteFolderVideoTile tile) => tile.video.title)
        .toList(growable: false);

    expect(titles, <String>[
      'Beach Sunset.mp4',
      'Campfire.mp4',
      'Travel Vlog.mp4',
    ]);
  });

  testWidgets('detail page confirms before deleting selected videos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FavoriteFolderDetailPage(folder: _buildDetailFolders()[1]),
      ),
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Travel Vlog.mp4'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('\u5168\u9009'), findsOneWidget);
    expect(find.byTooltip('\u5220\u9664'), findsOneWidget);

    await tester.tap(find.byTooltip('\u5168\u9009'));
    await tester.pumpAndSettle();

    expect(find.text('\u5df2\u9009\u62e9 3 \u9879'), findsOneWidget);

    await tester.tap(find.byTooltip('\u5220\u9664'));
    await tester.pumpAndSettle();

    expect(find.text('\u5220\u9664\u89c6\u9891'), findsOneWidget);
    expect(
      find.text(
        '\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684 3 \u4e2a\u89c6\u9891\u5417\uff1f',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('\u5220\u9664'));
    await tester.pumpAndSettle();

    expect(find.byType(FavoriteFolderVideoTile), findsNothing);
    expect(
      find.text('\u5f53\u524d\u6536\u85cf\u5939\u8fd8\u6ca1\u6709\u89c6\u9891'),
      findsOneWidget,
    );
  });
}

List<FavoriteFolderEntry> _buildDetailFolders() {
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
      createdAt: DateTime(2026, 3, 9, 8),
      videos: <FavoriteVideoEntry>[
        FavoriteVideoEntry(
          id: 'travel-vlog',
          title: 'Travel Vlog.mp4',
          durationText: '12:40',
          durationMs: 760000,
          updatedAt: DateTime(2026, 3, 9, 9),
          previewSeed: 1,
        ),
        FavoriteVideoEntry(
          id: 'beach-sunset',
          title: 'Beach Sunset.mp4',
          durationText: '08:16',
          durationMs: 496000,
          updatedAt: DateTime(2026, 3, 9, 10),
          previewSeed: 2,
        ),
        FavoriteVideoEntry(
          id: 'campfire',
          title: 'Campfire.mp4',
          durationText: '05:03',
          durationMs: 303000,
          updatedAt: DateTime(2026, 3, 9, 11),
          previewSeed: 3,
        ),
      ],
    ),
  ];
}
