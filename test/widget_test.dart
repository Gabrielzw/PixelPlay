import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/app/pixelplay_app.dart';
import 'package:pixelplay/features/media_library/data/in_memory_media_library_repository.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/album_video_preview.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/album_video_tile.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/library_album_card.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';

PixelPlayApp buildTestApp() {
  return PixelPlayApp(
    settingsRepository: InMemorySettingsRepository(),
    mediaLibraryRepository: const InMemoryMediaLibraryRepository(),
  );
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('shows bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('shows local albums from repository', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(
      find.byType(LibraryAlbumCard),
      findsNWidgets(kDemoLocalAlbums.length),
    );
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Download'), findsOneWidget);
  });

  testWidgets('android back pops album to library', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LibraryAlbumCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(LibraryAlbumCard), findsNothing);
    expect(find.text('Screenshots'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(
      find.byType(LibraryAlbumCard),
      findsNWidgets(kDemoLocalAlbums.length),
    );
  });

  testWidgets('shows album videos without thumbnails', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LibraryAlbumCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlbumVideoTile), findsWidgets);
    expect(find.byType(AlbumVideoPreview), findsNothing);
    expect(find.text('Beach Walk.mp4'), findsOneWidget);
    expect(find.text('03:35 · 151 MB'), findsOneWidget);
  });
}
