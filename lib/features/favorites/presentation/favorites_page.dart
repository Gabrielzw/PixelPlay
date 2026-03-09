import 'package:flutter/material.dart';

import '../../playlist_sources/presentation/controllers/playlist_sources_controller.dart';
import '../../playlist_sources/presentation/playlist_source_models.dart';
import '../../playlist_sources/presentation/playlist_sources_tab_view.dart';
import 'controllers/favorites_controller.dart';
import 'favorite_folders_tab_view.dart';
import 'favorite_models.dart';

class FavoritesPage extends StatelessWidget {
  final List<FavoriteFolderEntry>? initialFolders;
  final FavoritesController? favoritesController;
  final List<PlaylistSourceEntry>? initialPlaylistSources;
  final PlaylistSourcesController? playlistSourcesController;

  const FavoritesPage({
    super.key,
    this.initialFolders,
    this.favoritesController,
    this.initialPlaylistSources,
    this.playlistSourcesController,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('收藏'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '收藏夹'),
              Tab(text: '播放列表'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            FavoriteFoldersTabView(
              initialFolders: initialFolders,
              favoritesController: favoritesController,
            ),
            PlaylistSourcesTabView(
              initialEntries: initialPlaylistSources,
              playlistSourcesController: playlistSourcesController,
            ),
          ],
        ),
      ),
    );
  }
}
