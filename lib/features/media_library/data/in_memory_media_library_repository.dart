import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';

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
    videoCount: 405,
    latestDateAddedSeconds: kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds,
  ),
  LocalAlbum(
    bucketId: 'demo_download',
    bucketName: 'Download',
    videoCount: 6,
    latestDateAddedSeconds: kDemoAlbumDateAddedSeconds - kDemoAlbumDateAddedStepSeconds * 2,
  ),
];

class InMemoryMediaLibraryRepository implements MediaLibraryRepository {
  final List<LocalAlbum> albums;
  final bool permissionGranted;

  const InMemoryMediaLibraryRepository({
    this.albums = kDemoLocalAlbums,
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
}

