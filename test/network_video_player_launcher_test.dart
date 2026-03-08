import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/media_library/presentation/network_video_player_launcher.dart';
import 'package:pixelplay/shared/domain/media_source_kind.dart';

void main() {
  test('buildNetworkVideoPlayerItem maps url to other source item', () {
    final item = buildNetworkVideoPlayerItem(
      'https://media.example.com/videos/trailer.mp4?token=1',
    );

    expect(item.id, 'https://media.example.com/videos/trailer.mp4?token=1');
    expect(item.title, 'trailer.mp4');
    expect(item.sourceLabel, '\u5176\u4ed6 / media.example.com');
    expect(
      item.sourceUri,
      'https://media.example.com/videos/trailer.mp4?token=1',
    );
    expect(item.sourceKind, MediaSourceKind.other);
    expect(item.isRemote, isTrue);
  });

  test('parseNetworkVideoUri rejects non-network urls', () {
    expect(
      () => parseNetworkVideoUri('file:///storage/emulated/0/video.mp4'),
      throwsFormatException,
    );
    expect(() => parseNetworkVideoUri('not a url'), throwsFormatException);
  });
}
