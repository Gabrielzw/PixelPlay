import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/media_library/data/in_memory_media_library_repository.dart';
import 'package:pixelplay/features/media_library/presentation/album_video_sort_type.dart';

void main() {
  test('sortAlbumVideos supports all album sort options', () {
    final videos = kDemoAlbumVideos['demo_screenshots']!;

    expect(
      sortAlbumVideos(
        videos,
        AlbumVideoSortType.latest,
      ).map((video) => video.id).toList(growable: false),
      <int>[1, 2, 3, 4],
    );
    expect(
      sortAlbumVideos(
        videos,
        AlbumVideoSortType.oldest,
      ).map((video) => video.id).toList(growable: false),
      <int>[4, 3, 2, 1],
    );
    expect(
      sortAlbumVideos(
        videos,
        AlbumVideoSortType.nameAsc,
      ).map((video) => video.id).toList(growable: false),
      <int>[1, 2, 3, 4],
    );
    expect(
      sortAlbumVideos(
        videos,
        AlbumVideoSortType.nameDesc,
      ).map((video) => video.id).toList(growable: false),
      <int>[4, 3, 2, 1],
    );
    expect(
      sortAlbumVideos(
        videos,
        AlbumVideoSortType.sizeAsc,
      ).map((video) => video.id).toList(growable: false),
      <int>[3, 4, 2, 1],
    );
    expect(
      sortAlbumVideos(
        videos,
        AlbumVideoSortType.sizeDesc,
      ).map((video) => video.id).toList(growable: false),
      <int>[1, 2, 4, 3],
    );
  });
}
