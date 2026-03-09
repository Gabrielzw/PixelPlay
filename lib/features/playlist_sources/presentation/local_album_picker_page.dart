import 'package:flutter/material.dart';

import '../../../app/router/page_navigation.dart';
import '../../media_library/domain/contracts/media_library_repository.dart';
import '../../media_library/domain/entities/local_album.dart';
import '../../media_library/presentation/album_page.dart';
import 'playlist_source_models.dart';

class LocalAlbumPickerPage extends StatelessWidget {
  final MediaLibraryRepository repository;

  const LocalAlbumPickerPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择本地相册')),
      body: FutureBuilder<List<LocalAlbum>>(
        future: repository.loadLocalAlbums(),
        builder:
            (BuildContext context, AsyncSnapshot<List<LocalAlbum>> snapshot) {
              if (snapshot.hasError) {
                return _AlbumPickerFailureView(
                  message: snapshot.error.toString(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final albums = snapshot.requireData;
              if (albums.isEmpty) {
                return const _AlbumPickerEmptyView();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: albums.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int index) {
                  final album = albums[index];
                  return Card(
                    child: ListTile(
                      onTap: () => Navigator.of(context).pop(album),
                      onLongPress: () => _openAlbumPreview(context, album),
                      leading: const CircleAvatar(
                        child: Icon(Icons.photo_library_outlined),
                      ),
                      title: Text(resolvePlaylistAlbumTitle(album.bucketName)),
                      subtitle: Text('${album.videoCount} 个视频'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  );
                },
              );
            },
      ),
    );
  }

  Future<void> _openAlbumPreview(BuildContext context, LocalAlbum album) {
    return pushRootPage<void>(
      context,
      (_) => AlbumPage(album: album, repository: repository),
    );
  }
}

class _AlbumPickerEmptyView extends StatelessWidget {
  const _AlbumPickerEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('未找到可添加的本地相册。'));
  }
}

class _AlbumPickerFailureView extends StatelessWidget {
  final String message;

  const _AlbumPickerFailureView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
