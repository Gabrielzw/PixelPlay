import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/favorites/data/in_memory_favorites_repository.dart';
import 'package:pixelplay/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:pixelplay/features/favorites/presentation/favorite_models.dart';
import 'package:pixelplay/features/player_core/domain/player_queue_item.dart';
import 'package:pixelplay/features/player_core/presentation/widgets/player_favorite_panel.dart';

void main() {
  testWidgets('player favorite panel opens and confirms adding video', (
    WidgetTester tester,
  ) async {
    final favoritesController = _createFavoritesController();

    await tester.pumpWidget(
      _buildPanelApp(
        child: _FavoritePanelTestHost(favoritesController: favoritesController),
      ),
    );

    expect(find.text('加入收藏'), findsNothing);

    await tester.tap(find.text('打开收藏面板'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('加入收藏'), findsOneWidget);
    expect(find.text(kDefaultFavoriteFolderTitle), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, '新建收藏夹'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '确认'), findsOneWidget);

    await tester.tap(find.text(kDefaultFavoriteFolderTitle));
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.widgetWithText(FilledButton, '确认'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 200));

    final folders = favoritesController.folders.toList(growable: false);
    expect(folders.single.videos.single.title, 'Test Clip.mp4');
    expect(find.text('加入收藏'), findsNothing);
  });

  testWidgets('player favorite panel creates folder from bottom button', (
    WidgetTester tester,
  ) async {
    final favoritesController = _createFavoritesController();

    await tester.pumpWidget(
      _buildPanelApp(
        child: Scaffold(
          body: PlayerFavoritePanel(
            favoritesController: favoritesController,
            item: _buildQueueItem(),
            visible: true,
            onClose: () {},
            onCreateFolder: () async {
              return favoritesController.createFolder(title: '电影合集');
            },
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.widgetWithText(OutlinedButton, '新建收藏夹'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('电影合集'), findsOneWidget);
  });

  testWidgets('player favorite panel preselects folders containing video', (
    WidgetTester tester,
  ) async {
    final favoritesController = _createFavoritesController();
    favoritesController.addQueueItemToFolders(
      item: _buildQueueItem(),
      folderIds: <String>{kDefaultFavoriteFolderId},
    );

    await tester.pumpWidget(
      _buildPanelApp(
        child: Scaffold(
          body: PlayerFavoritePanel(
            favoritesController: favoritesController,
            item: _buildQueueItem(),
            visible: true,
            onClose: () {},
            onCreateFolder: () async => null,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
    expect(checkbox.value, isTrue);
  });

  testWidgets('player favorite panel removes video when folder unchecked', (
    WidgetTester tester,
  ) async {
    final favoritesController = _createFavoritesController();
    favoritesController.addQueueItemToFolders(
      item: _buildQueueItem(),
      folderIds: <String>{kDefaultFavoriteFolderId},
    );

    await tester.pumpWidget(
      _buildPanelApp(
        child: Scaffold(
          body: PlayerFavoritePanel(
            favoritesController: favoritesController,
            item: _buildQueueItem(),
            visible: true,
            onClose: () {},
            onCreateFolder: () async => null,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.widgetWithText(FilledButton, '确认'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 200));

    expect(favoritesController.folders.single.videos, isEmpty);
  });
}

FavoritesController _createFavoritesController() {
  final favoritesController = FavoritesController(
    repository: InMemoryFavoritesRepository(),
  );
  favoritesController.refreshFolders();
  return favoritesController;
}

Widget _buildPanelApp({required Widget child}) {
  return MaterialApp(
    navigatorObservers: <NavigatorObserver>[FlutterSmartDialog.observer],
    builder: FlutterSmartDialog.init(),
    home: child,
  );
}

PlayerQueueItem _buildQueueItem() {
  return PlayerQueueItem(
    id: 'video-1',
    title: 'Test Clip.mp4',
    sourceLabel: 'Camera',
    path: '/storage/emulated/0/DCIM/Test Clip.mp4',
    duration: const Duration(minutes: 3, seconds: 25),
    localVideoId: 1,
    localVideoDateModified: 123,
  );
}

class _FavoritePanelTestHost extends StatefulWidget {
  final FavoritesController favoritesController;

  const _FavoritePanelTestHost({required this.favoritesController});

  @override
  State<_FavoritePanelTestHost> createState() => _FavoritePanelTestHostState();
}

class _FavoritePanelTestHostState extends State<_FavoritePanelTestHost> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _visible = true;
                });
              },
              child: const Text('打开收藏面板'),
            ),
          ),
          PlayerFavoritePanel(
            favoritesController: widget.favoritesController,
            item: _buildQueueItem(),
            visible: _visible,
            onClose: () {
              setState(() {
                _visible = false;
              });
            },
            onCreateFolder: () async => null,
          ),
        ],
      ),
    );
  }
}
