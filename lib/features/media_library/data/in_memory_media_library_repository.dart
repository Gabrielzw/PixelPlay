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
    latestVideoId: 1,
    latestVideoPath: 'content://media/external/video/media/1',
    latestVideoDateModified: kDemoAlbumDateAddedSeconds - 180,
  ),
  LocalAlbum(
    bucketId: 'demo_camera',
    bucketName: 'Camera',
    videoCount: 3,
    latestDateAddedSeconds:
        kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds,
    latestVideoId: 5,
    latestVideoPath: 'content://media/external/video/media/5',
    latestVideoDateModified:
        kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds - 120,
  ),
  LocalAlbum(
    bucketId: 'demo_download',
    bucketName: 'Download',
    videoCount: 2,
    latestDateAddedSeconds:
        kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds * 2,
    latestVideoId: 8,
    latestVideoPath: 'content://media/external/video/media/8',
    latestVideoDateModified:
        kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds * 2 - 90,
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
      width: 1920,
      height: 1080,
      dateModified: kDemoAlbumDateAddedSeconds - 180,
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
      width: 1280,
      height: 720,
      dateModified: kDemoAlbumDateAddedSeconds - 780,
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
      width: 1080,
      height: 1920,
      dateModified: kDemoAlbumDateAddedSeconds - 1320,
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
      width: 1080,
      height: 1920,
      dateModified: kDemoAlbumDateAddedSeconds - 2010,
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
      width: 3840,
      height: 2160,
      dateModified:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds - 120,
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
      width: 1920,
      height: 1080,
      dateModified:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds - 750,
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
      width: 1280,
      height: 720,
      dateModified:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds - 1410,
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
      width: 3840,
      height: 2160,
      dateModified:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds * 2 - 90,
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
      width: 2560,
      height: 1440,
      dateModified:
          kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds * 2 - 960,
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
