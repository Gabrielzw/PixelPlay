import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/favorites/presentation/favorite_folder_detail_page.dart';
import 'package:pixelplay/features/favorites/presentation/favorite_models.dart';
import 'package:pixelplay/features/favorites/presentation/favorites_page.dart';
import 'package:pixelplay/features/favorites/presentation/widgets/favorite_folder_preview.dart';

void main() {
  testWidgets('tapping folder opens detail page with hero header and toolbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: FavoritesPage(initialFolders: _buildDetailFolders())),
    );

    await tester.tap(find.text('旅行收藏'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.byTooltip('返回'), findsOneWidget);
    expect(find.byTooltip('搜索'), findsOneWidget);
    expect(find.byTooltip('排序'), findsOneWidget);
    expect(find.byTooltip('更多'), findsOneWidget);
    expect(find.text('旅行收藏'), findsOneWidget);
    expect(find.text('2 个视频'), findsOneWidget);
    expect(find.text('旅行Vlog.mp4'), findsOneWidget);
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

    await tester.longPress(find.text('旅行Vlog.mp4'));
    await tester.pumpAndSettle();

    expect(find.text('已选择 1 项'), findsOneWidget);
    expect(find.byTooltip('取消选择'), findsOneWidget);

    await tester.tap(find.text('海边日落.mp4'));
    await tester.pumpAndSettle();

    expect(find.text('已选择 2 项'), findsOneWidget);
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
      title: '旅行收藏',
      createdAt: DateTime(2026, 3, 9, 8),
      videos: <FavoriteVideoEntry>[
        FavoriteVideoEntry(
          id: 'travel-vlog',
          title: '旅行Vlog.mp4',
          durationText: '12:40',
          updatedAt: DateTime(2026, 3, 9, 9),
          previewSeed: 1,
        ),
        FavoriteVideoEntry(
          id: 'beach-sunset',
          title: '海边日落.mp4',
          durationText: '08:16',
          updatedAt: DateTime(2026, 3, 9, 10),
          previewSeed: 2,
        ),
      ],
    ),
  ];
}
