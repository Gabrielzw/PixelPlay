import 'package:shared_preferences/shared_preferences.dart';

import '../domain/playback_position_repository.dart';

const String _positionKeyPrefix = 'player.position.';
const String _durationKeyPrefix = 'player.duration.';

class SharedPreferencesPlaybackPositionRepository
    implements PlaybackPositionRepository {
  final SharedPreferences preferences;

  const SharedPreferencesPlaybackPositionRepository({
    required this.preferences,
  });

  @override
  Future<PlaybackPositionRecord?> load(String mediaId) async {
    final positionMs = preferences.getInt('$_positionKeyPrefix$mediaId');
    final durationMs = preferences.getInt('$_durationKeyPrefix$mediaId');
    if (positionMs == null || durationMs == null) {
      return null;
    }

    return PlaybackPositionRecord(
      mediaId: mediaId,
      positionMs: positionMs,
      durationMs: durationMs,
    );
  }

  @override
  Future<void> save(PlaybackPositionRecord record) async {
    final results = await Future.wait<bool>(<Future<bool>>[
      preferences.setInt(
        '$_positionKeyPrefix${record.mediaId}',
        record.positionMs,
      ),
      preferences.setInt(
        '$_durationKeyPrefix${record.mediaId}',
        record.durationMs,
      ),
    ]);
    if (results.any((bool result) => result == false)) {
      throw StateError('Failed to persist playback position.');
    }
  }

  @override
  Future<void> clear(String mediaId) async {
    await Future.wait<bool>(<Future<bool>>[
      preferences.remove('$_positionKeyPrefix$mediaId'),
      preferences.remove('$_durationKeyPrefix$mediaId'),
    ]);
  }
}
