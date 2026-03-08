import '../domain/playback_position_repository.dart';

class InMemoryPlaybackPositionRepository implements PlaybackPositionRepository {
  final Map<String, PlaybackPositionRecord> _records =
      <String, PlaybackPositionRecord>{};

  @override
  Future<PlaybackPositionRecord?> load(String mediaId) async {
    return _records[mediaId];
  }

  @override
  Future<void> save(PlaybackPositionRecord record) async {
    _records[record.mediaId] = record;
  }

  @override
  Future<void> clear(String mediaId) async {
    _records.remove(mediaId);
  }
}
