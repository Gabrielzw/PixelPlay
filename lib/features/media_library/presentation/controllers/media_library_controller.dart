import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/contracts/media_library_repository.dart';
import '../../domain/entities/local_album.dart';

sealed class MediaLibraryViewState {
  const MediaLibraryViewState();
}

class MediaLibraryLoadingState extends MediaLibraryViewState {
  const MediaLibraryLoadingState();
}

class MediaLibraryPermissionRequiredState extends MediaLibraryViewState {
  const MediaLibraryPermissionRequiredState();
}

@immutable
class MediaLibraryReadyState extends MediaLibraryViewState {
  final List<LocalAlbum> albums;

  const MediaLibraryReadyState({required this.albums});
}

@immutable
class MediaLibraryFailureState extends MediaLibraryViewState {
  final Object error;
  final StackTrace stackTrace;

  const MediaLibraryFailureState({required this.error, required this.stackTrace});
}

class MediaLibraryController extends GetxController {
  final MediaLibraryRepository repository;
  final Rx<MediaLibraryViewState> state =
      Rx<MediaLibraryViewState>(const MediaLibraryLoadingState());

  MediaLibraryController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    refreshAlbums();
  }

  Future<void> refreshAlbums() async {
    await _loadAlbums(requestPermissionIfMissing: false);
  }

  Future<void> requestPermissionAndRefresh() async {
    await _loadAlbums(requestPermissionIfMissing: true);
  }

  Future<void> _loadAlbums({required bool requestPermissionIfMissing}) async {
    state.value = const MediaLibraryLoadingState();

    try {
      final hasPermission = requestPermissionIfMissing
          ? await repository.requestVideoPermission()
          : await repository.hasVideoPermission();
      if (!hasPermission) {
        state.value = const MediaLibraryPermissionRequiredState();
        return;
      }

      final albums = await repository.loadLocalAlbums();
      state.value = MediaLibraryReadyState(albums: albums);
    } catch (error, stackTrace) {
      state.value = MediaLibraryFailureState(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
