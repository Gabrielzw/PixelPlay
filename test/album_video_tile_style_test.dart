import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/features/media_library/presentation/widgets/album_video_tile.dart';
import 'package:pixelplay/features/thumbnail_engine/data/in_memory_thumbnail_queue.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/thumbnail_queue.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/video_thumbnail_request.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put<ThumbnailQueue>(InMemoryThumbnailQueue());
  });

  testWidgets('album video tile uses library card surface and shadow', (
    WidgetTester tester,
  ) async {
    final theme = ThemeData(useMaterial3: true);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: theme,
        home: Scaffold(
          body: AlbumVideoTile(
            data: AlbumVideoTileData(
              id: '1',
              title: 'Test Video.mp4',
              durationText: '01:00',
              resolutionText: '1920×1080',
              sizeText: '100 MB',
              modifiedTimeText: '2025-01-01 12:00',
              previewSeed: 1,
              thumbnailRequest: VideoThumbnailRequest.tile(
                videoId: 1,
                videoPath: 'content://test/video/1',
                dateModified: 1,
              ),
            ),
            onTap: () {},
          ),
        ),
      ),
    );

    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(AlbumVideoTile),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.color, theme.colorScheme.surface);

    final decoratedBox = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(AlbumVideoTile),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = decoratedBox.decoration as BoxDecoration;

    expect(decoration.boxShadow, isNotEmpty);
    expect(decoration.boxShadow!.first.blurRadius, 18);
    expect(decoration.boxShadow!.first.offset, const Offset(0, 10));
  });

  testWidgets('album video tile shows playback progress on preview', (
    WidgetTester tester,
  ) async {
    final theme = ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: theme,
        home: Scaffold(
          body: AlbumVideoTile(
            data: AlbumVideoTileData(
              id: '2',
              title: 'Resume Video.mp4',
              durationText: '01:20/02:40',
              resolutionText: '1920脳1080',
              sizeText: '220 MB',
              modifiedTimeText: '2025-01-01 13:00',
              progressRatio: 0.5,
              previewSeed: 2,
              thumbnailRequest: VideoThumbnailRequest.tile(
                videoId: 2,
                videoPath: 'content://test/video/2',
                dateModified: 2,
              ),
            ),
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('01:20/02:40'), findsOneWidget);

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );

    expect(indicator.value, 0.5);
    expect(indicator.color, theme.colorScheme.primary);
  });
}
