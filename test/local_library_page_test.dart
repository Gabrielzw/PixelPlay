import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/app/pixelplay_app.dart';
import 'package:pixelplay/features/media_library/data/in_memory_media_library_repository.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/library_album_card.dart';
import 'package:pixelplay/features/player_core/data/in_memory_playback_position_repository.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/thumbnail_engine/data/in_memory_thumbnail_queue.dart';
import 'package:pixelplay/features/watch_history/data/in_memory_watch_history_repository.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_account_repository.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_browser_repository.dart';

PixelPlayApp _buildTestApp() {
  return PixelPlayApp(
    settingsRepository: InMemorySettingsRepository(),
    mediaLibraryRepository: const InMemoryMediaLibraryRepository(),
    thumbnailQueue: InMemoryThumbnailQueue(),
    playbackPositionRepository: InMemoryPlaybackPositionRepository(),
    watchHistoryRepository: InMemoryWatchHistoryRepository(),
    webDavAccountRepository: InMemoryWebDavAccountRepository(),
    webDavBrowserRepository: const InMemoryWebDavBrowserRepository(),
  );
}

List<String> _albumTitles(WidgetTester tester) {
  return tester
      .widgetList<LibraryAlbumCard>(find.byType(LibraryAlbumCard))
      .map((LibraryAlbumCard card) => card.album.title)
      .toList(growable: false);
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets(
    'shows player, history, search and sort actions on library app bar',
    (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(
        find.byTooltip('\u64ad\u653e\u7f51\u7edc\u89c6\u9891'),
        findsOneWidget,
      );
      expect(find.byTooltip('\u89c2\u770b\u8bb0\u5f55'), findsOneWidget);
      expect(find.byTooltip('\u641c\u7d22'), findsOneWidget);
      expect(find.byTooltip('\u6392\u5e8f'), findsOneWidget);
    },
  );

  testWidgets('opens network video dialog from library app bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('\u64ad\u653e\u7f51\u7edc\u89c6\u9891'));
    await tester.pumpAndSettle();

    expect(find.text('\u64ad\u653e\u7f51\u7edc\u89c6\u9891'), findsOneWidget);
    expect(find.text('\u7f51\u7edc\u89c6\u9891\u5730\u5740'), findsOneWidget);
    expect(find.text('\u64ad\u653e'), findsOneWidget);
    expect(find.text('\u53d6\u6d88'), findsOneWidget);

    await tester.tap(find.text('\u64ad\u653e'));
    await tester.pump();

    expect(
      find.text('\u8bf7\u8f93\u5165\u7f51\u7edc\u89c6\u9891\u5730\u5740\u3002'),
      findsOneWidget,
    );
  });

  testWidgets('opens watch history page from library app bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('\u89c2\u770b\u8bb0\u5f55'));
    await tester.pumpAndSettle();

    expect(find.text('\u89c2\u770b\u8bb0\u5f55'), findsOneWidget);
    expect(find.byTooltip('\u641c\u7d22'), findsOneWidget);
    expect(find.byTooltip('\u9009\u9879'), findsOneWidget);
  });

  testWidgets('search finds album results and video results separately', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('\u641c\u7d22'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'screen');
    await tester.pumpAndSettle();

    expect(find.text('\u76f8\u518c'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.byType(LibraryAlbumCard), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'clip');
    await tester.pumpAndSettle();

    expect(find.text('\u89c6\u9891'), findsOneWidget);
    expect(find.text('Cafe Clip.mp4'), findsOneWidget);
    expect(find.text('\u76f8\u518c \u00b7 Camera'), findsOneWidget);
  });

  testWidgets('sorts library albums by name in both directions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(_albumTitles(tester), <String>['Screenshots', 'Camera', 'Download']);

    await tester.tap(find.byTooltip('\u6392\u5e8f'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u540d\u79f0 A-Z').last);
    await tester.pumpAndSettle();

    expect(_albumTitles(tester), <String>['Camera', 'Download', 'Screenshots']);

    await tester.tap(find.byTooltip('\u6392\u5e8f'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u540d\u79f0 Z-A').last);
    await tester.pumpAndSettle();

    expect(_albumTitles(tester), <String>['Screenshots', 'Download', 'Camera']);
  });
}
