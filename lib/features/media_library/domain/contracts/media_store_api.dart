import '../entities/native_video_record.dart';

abstract interface class MediaStoreApi {
  Future<List<NativeVideoRecord>> scanLocalVideos();
}
