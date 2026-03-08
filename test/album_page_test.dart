import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:pixelplay/features/media_library/data/in_memory_media_library_repository.dart';
import 'package:pixelplay/features/media_library/domain/contracts/media_library_repository.dart';
import 'package:pixelplay/features/media_library/domain/entities/local_album.dart';
import 'package:pixelplay/features/media_library/domain/entities/local_video.dart';
import 'package:pixelplay/features/media_library/presentation/album_page.dart';
import 'package:pixelplay/features/media_library/presentation/album_video_sort_type.dart';
import 'package:pixelplay/features/media_library/presentation/widgets/album_video_tile.dart';
import 'package:pixelplay/features/thumbnail_engine/data/in_memory_thumbnail_queue.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/thumbnail_queue.dart';

class _MutableMediaLibraryRepository implements MediaLibraryRepository {
  final List<LocalAlbum> _albums;
  final Map<String, List<LocalVideo>> _albumVideos;

  _MutableMediaLibraryRepository({
    required List<LocalAlbum> albums,
    required Map<String, List<LocalVideo>> albumVideos,
  }) : _albums = List<LocalAlbum>.from(albums),
       _albumVideos = <String, List<LocalVideo>>{
         for (final MapEntry<String, List<LocalVideo>> entry
             in albumVideos.entries)
           entry.key: List<LocalVideo>.from(entry.value),
       };

  @override
  Future<bool> hasVideoPermission() async => true;

  @override
  Future<List<LocalAlbum>> loadLocalAlbums() async {
    return List<LocalAlbum>.unmodifiable(_albums);
  }

  @override
  Future<List<LocalVideo>> loadAlbumVideos(String bucketId) async {
    return List<LocalVideo>.unmodifiable(
      _albumVideos[bucketId] ?? <LocalVideo>[],
    );
  }

  @override
  Future<bool> requestVideoPermission() async => true;

  void updateVideo(LocalVideo target) {
    final videos = _albumVideos[target.bucketId];
    if (videos == null) {
      throw StateError('Missing bucket ${target.bucketId}.');
    }

    final index = videos.indexWhere(
      (LocalVideo video) => video.id == target.id,
    );
    if (index < 0) {
      throw StateError('Missing video ${target.id}.');
    }
    videos[index] = target;
  }
}

class _AutoPopPage extends StatefulWidget {
  final VoidCallback onReady;

  const _AutoPopPage({required this.onReady});

  @override
  State<_AutoPopPage> createState() => _AutoPopPageState();
}

class _AutoPopPageState extends State<_AutoPopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onReady();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put<ThumbnailQueue>(InMemoryThumbnailQueue());
  });

  testWidgets('album page search filters videos in current album', (
    WidgetTester tester,
  ) async {
    const repository = InMemoryMediaLibraryRepository();

    await tester.pumpWidget(
      GetMaterialApp(
        home: AlbumPage(album: kDemoLocalAlbums.first, repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Beach Walk.mp4'), findsOneWidget);

    await tester.tap(find.byTooltip('搜索'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'UI');
    await tester.pumpAndSettle();

    expect(find.text('UI Capture 01.mp4'), findsOneWidget);
    expect(find.text('UI Capture 02.mp4'), findsOneWidget);
    expect(find.text('Beach Walk.mp4'), findsNothing);
  });

  testWidgets('album page sort menu includes size options and reorders list', (
    WidgetTester tester,
  ) async {
    const repository = InMemoryMediaLibraryRepository();

    await tester.pumpWidget(
      GetMaterialApp(
        home: AlbumPage(album: kDemoLocalAlbums.first, repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('排序'));
    await tester.pumpAndSettle();

    expect(find.text(AlbumVideoSortType.latest.label), findsOneWidget);
    expect(find.text(AlbumVideoSortType.oldest.label), findsOneWidget);
    expect(find.text(AlbumVideoSortType.nameAsc.label), findsOneWidget);
    expect(find.text(AlbumVideoSortType.nameDesc.label), findsOneWidget);
    expect(find.text(AlbumVideoSortType.sizeAsc.label), findsOneWidget);
    expect(find.text(AlbumVideoSortType.sizeDesc.label), findsOneWidget);

    await tester.tap(find.text(AlbumVideoSortType.sizeAsc.label).last);
    await tester.pumpAndSettle();

    final titles = tester
        .widgetList<AlbumVideoTile>(find.byType(AlbumVideoTile))
        .map((AlbumVideoTile tile) => tile.data.title)
        .toList(growable: false);

    expect(titles, <String>[
      'UI Capture 01.mp4',
      'UI Capture 02.mp4',
      'Frame Compare.mov',
      'Beach Walk.mp4',
    ]);
  });

  testWidgets('album page refreshes playback record after returning', (
    WidgetTester tester,
  ) async {
    final repository = _MutableMediaLibraryRepository(
      albums: kDemoLocalAlbums,
      albumVideos: kDemoAlbumVideos,
    );
    final originalVideo = kDemoAlbumVideos['demo_screenshots']!.first;

    await tester.pumpWidget(
      GetMaterialApp(
        home: AlbumPage(
          album: kDemoLocalAlbums.first,
          repository: repository,
          playerRouteBuilder: (playlist, initialIndex) {
            return MaterialPageRoute<void>(
              builder: (BuildContext context) => _AutoPopPage(
                onReady: () {
                  repository.updateVideo(
                    originalVideo.copyWith(lastPlayPositionMs: 80000),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('03:35'), findsOneWidget);
    expect(find.text('01:20/03:35'), findsNothing);

    await tester.tap(find.text('Beach Walk.mp4'));
    await tester.pumpAndSettle();

    expect(find.text('01:20/03:35'), findsOneWidget);
  });
}
