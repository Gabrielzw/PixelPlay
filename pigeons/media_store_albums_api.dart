import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'pixelplay',
    dartOut:
        'lib/features/media_library/data/pigeon/media_store_albums_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/media/gabriel/pixelplay/pigeon/media_store_albums_api.g.kt',
    kotlinOptions: KotlinOptions(package: 'media.gabriel.pixelplay.pigeon'),
  ),
)
// ignore: unused_element
class _PigeonConfig {
  String? sentinel;
}

class NativeAlbumRecord {
  late String bucketId;
  late String bucketName;
  late int videoCount;
  late int latestDateAddedSeconds;
  late int latestVideoId;
  late String latestVideoPath;
  late int latestVideoDateModified;
}

class NativeVideoRecord {
  late String id;
  late String path;
  late String name;
  late String bucketId;
  late String bucketName;
  late int durationMs;
  late int size;
  late int dateAdded;
  late int width;
  late int height;
  late int dateModified;
}

class NativeThumbnailRequest {
  late int videoId;
  late String videoPath;
  late int targetWidth;
  late int targetHeight;
  late int dateModified;
}

@HostApi()
abstract class MediaStoreAlbumsApi {
  @async
  bool hasVideoPermission();

  @async
  bool requestVideoPermission();

  @async
  List<NativeAlbumRecord> scanLocalVideoAlbums();

  @async
  List<NativeVideoRecord> scanAlbumVideos(String bucketId);

  @async
  String resolveVideoThumbnail(NativeThumbnailRequest request);

  @async
  void clearThumbnailCache();
}
