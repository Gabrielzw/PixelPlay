import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import '../domain/entities/local_video.dart';

const int kDemoAlbumDateAddedSeconds = 1_700_000_000;
const int kDemoAlbumDateAddedStepSeconds = 2_400;

const List<LocalAlbum> kDemoLocalAlbums = <LocalAlbum>[
  LocalAlbum(
    bucketId: 'demo_screenshots',
    bucketName: 'Screenshots',
    videoCount: 4,
    latestDateAddedSeconds: kDemoAlbumDateAddedSeconds,
  ),
  LocalAlbum(
    bucketId: 'demo_camera',
    bucketName: 'Camera',
    videoCount: 3,
    latestDateAddedSeconds:
        kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds,
  ),
  LocalAlbum(
    bucketId: 'demo_download',
    bucketName: 'Download',
    videoCount: 2,
    latestDateAddedSeconds:
        kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds * 2,
  ),
];

const Map<String, List<LocalVideo>>
kDemoAlbumVideos = <String, List<LocalVideo>>{
  'demo_screenshots': <LocalVideo>[
    LocalVideo(
      id: 1,
      path: 'content://media/external/video/media/1',
      title: 'Beach Walk.mp4',
      bucketId: 'demo_screenshots',
      bucketName: 'Screenshots',
      durationMs: 215000,
      size: 158334976,
      dateAdded: kDemoAlbumDateAddedSeconds,
    ),
    LocalVideo(
      id: 2,
      path: 'content://media/external/video/media/2',
      title: 'Frame Compare.mov',
      bucketId: 'demo_screenshots',
      bucketName: 'Screenshots',
      durationMs: 98000,
      size: 82313216,
      dateAdded: kDemoAlbumDateAddedSeconds - 600,
    ),
    LocalVideo(
      id: 3,
      path: 'content://media/external/video/media/3',
      title: 'UI Capture 01.mp4',
      bucketId: 'demo_screenshots',
      bucketName: 'Screenshots',
      durationMs: 47000,
      size: 21823488,
      dateAdded: kDemoAlbumDateAddedSeconds - 1200,
    ),
    LocalVideo(
      id: 4,
      path: 'content://media/external/video/media/4',
      title: 'UI Capture 02.mp4',
      bucketId: 'demo_screenshots',
      bucketName: 'Screenshots',
      durationMs: 62000,
      size: 24788992,
      dateAdded: kDemoAlbumDateAddedSeconds - 1800,
    ),
  ],
  'demo_camera': <LocalVideo>[
    LocalVideo(
      id: 5,
      path: 'content://media/external/video/media/5',
      title: 'Street Night.mp4',
      bucketId: 'demo_camera',
      bucketName: 'Camera',
      durationMs: 612000,
      size: 644874240,
      dateAdded: kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds,
    ),
    LocalVideo(
      id: 6,
      path: 'content://media/external/video/media/6',
      title: 'Morning Ride.mp4',
      bucketId: 'demo_camera',
      bucketName: 'Camera',
      durationMs: 184000,
      size: 203423744,
      dateAdded:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds - 600,
    ),
    LocalVideo(
      id: 7,
      path: 'content://media/external/video/media/7',
      title: 'Cafe Clip.mp4',
      bucketId: 'demo_camera',
      bucketName: 'Camera',
      durationMs: 41000,
      size: 48365568,
      dateAdded:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds - 1200,
    ),
  ],
  'demo_download': <LocalVideo>[
    LocalVideo(
      id: 8,
      path: 'content://media/external/video/media/8',
      title: 'Trailer 4K.mp4',
      bucketId: 'demo_download',
      bucketName: 'Download',
      durationMs: 146000,
      size: 327155712,
      dateAdded:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds * 2,
    ),
    LocalVideo(
      id: 9,
      path: 'content://media/external/video/media/9',
      title: 'Tutorial Intro.mkv',
      bucketId: 'demo_download',
      bucketName: 'Download',
      durationMs: 539000,
      size: 519634944,
      dateAdded:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds * 2 - 600,
    ),
  ],
};

class InMemoryMediaLibraryRepository implements MediaLibraryRepository {
  final List<LocalAlbum> albums;
  final Map<String, List<LocalVideo>> albumVideos;
  final bool permissionGranted;

  const InMemoryMediaLibraryRepository({
    this.albums = kDemoLocalAlbums,
    this.albumVideos = kDemoAlbumVideos,
    this.permissionGranted = true,
  });

  @override
  Future<bool> hasVideoPermission() async => permissionGranted;

  @override
  Future<bool> requestVideoPermission() async => permissionGranted;

  @override
  Future<List<LocalAlbum>> loadLocalAlbums() async {
    return List<LocalAlbum>.unmodifiable(albums);
  }

  @override
  Future<List<LocalVideo>> loadAlbumVideos(String bucketId) async {
    return List<LocalVideo>.unmodifiable(
      albumVideos[bucketId] ?? const <LocalVideo>[],
    );
  }
}
