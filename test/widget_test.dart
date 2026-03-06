import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/app/pixelplay_app.dart';
import 'package:pixelplay/features/media_library/data/in_memory_media_library_repository.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/album_video_preview.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/album_video_tile.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/library_album_card.dart';
import 'package:pixelplay/features/player_core/data/in_memory_playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/playback_position_repository.dart';
import 'package:pixelplay/features/player_core/domain/player_playback_port.dart';
import 'package:pixelplay/features/player_core/domain/player_queue_item.dart';
import 'package:pixelplay/features/player_core/presentation/player_page.dart';
import 'package:pixelplay/features/settings/domain/settings_controller.dart';
import 'package:pixelplay/features/settings/data/in_memory_settings_repository.dart';
import 'package:pixelplay/features/thumbnail_engine/data/in_memory_thumbnail_queue.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_account_repository.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_browser_repository.dart';
import 'package:pixelplay/shared/utils/media_formatters.dart';

PixelPlayApp buildTestApp() {
  return PixelPlayApp(
    settingsRepository: InMemorySettingsRepository(),
    mediaLibraryRepository: const InMemoryMediaLibraryRepository(),
    thumbnailQueue: InMemoryThumbnailQueue(),
    playbackPositionRepository: InMemoryPlaybackPositionRepository(),
    webDavAccountRepository: InMemoryWebDavAccountRepository(),
    webDavBrowserRepository: const InMemoryWebDavBrowserRepository(),
  );
}

class FakePlayerPlaybackPort implements PlayerPlaybackPort {
  @override
  Stream<bool> get bufferingStream => const Stream<bool>.empty();

  @override
  Stream<bool> get completedStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get durationStream => const Stream<Duration>.empty();

  @override
  Stream<String> get errorStream => const Stream<String>.empty();

  @override
  Stream<bool> get playingStream => const Stream<bool>.empty();

  @override
  Stream<Duration> get positionStream => const Stream<Duration>.empty();

  @override
  Widget buildVideoView({required BoxFit fit}) {
    return const SizedBox.expand();
  }

  @override
  Future<void> disposePlayback() async {}

  @override
  Future<void> open(PlayerQueueItem item, {required bool play}) async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> play() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> setPlaybackSpeed(double speed) async {}

  @override
  Future<void> setVolume(double volume) async {}
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

  testWidgets('shows album videos with preview layout and metadata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LibraryAlbumCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlbumVideoTile), findsWidgets);
    expect(find.byType(AlbumVideoPreview), findsWidgets);
    expect(find.text('Beach Walk.mp4'), findsOneWidget);
    expect(find.textContaining('151 MB'), findsOneWidget);
    expect(
      find.text(
        formatChineseDateTime(
          DateTime.fromMillisecondsSinceEpoch(1_699_999_820 * 1000),
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('player page omits Anime4K action', (WidgetTester tester) async {
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = InMemoryPlaybackPositionRepository();
    final playbackPort = FakePlayerPlaybackPort();

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'video-1',
              title: 'Test Clip.mp4',
              sourceLabel: '鏈湴 / Screenshots',
              sourceUri: 'test://video-1',
              duration: Duration(minutes: 10),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.byIcon(Icons.more_vert_rounded), findsOneWidget);
    expect(find.textContaining('Anime4K'), findsNothing);
  });

  testWidgets('player page restores saved playback progress', (
    WidgetTester tester,
  ) async {
    final settingsRepository = InMemorySettingsRepository();
    final progressRepository = InMemoryPlaybackPositionRepository();
    final playbackPort = FakePlayerPlaybackPort();
    await progressRepository.save(
      const PlaybackPositionRecord(
        mediaId: 'video-2',
        positionMs: 120000,
        durationMs: 600000,
      ),
    );

    Get.put<SettingsController>(
      SettingsController(repository: settingsRepository),
    );
    Get.put<PlaybackPositionRepository>(progressRepository);

    await tester.pumpWidget(
      GetMaterialApp(
        home: PlayerPage(
          playbackPort: playbackPort,
          playlist: <PlayerQueueItem>[
            PlayerQueueItem(
              id: 'video-2',
              title: 'Resume.mp4',
              sourceLabel: '鏈湴 / Camera',
              sourceUri: 'test://video-2',
              duration: Duration(minutes: 10),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('已恢复播放进度'), findsOneWidget);
    expect(find.text('02:00'), findsOneWidget);
  });
}

