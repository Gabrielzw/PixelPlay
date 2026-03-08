import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../domain/player_screenshot_store_port.dart';

const String kPlayerScreenshotStoreChannelName =
    'pixelplay/player_screenshot_store';
const String kPlayerScreenshotStoreMethodName = 'saveScreenshot';

class MethodChannelPlayerScreenshotStore implements PlayerScreenshotStorePort {
  static const MethodChannel _channel = MethodChannel(
    kPlayerScreenshotStoreChannelName,
  );

  @override
  Future<String> saveScreenshot(Uint8List bytes) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('截图保存仅支持 Android 平台。');
    }

    final savedLocation = await _channel.invokeMethod<String>(
      kPlayerScreenshotStoreMethodName,
      <String, Object>{'bytes': bytes},
    );
    if (savedLocation == null || savedLocation.isEmpty) {
      throw StateError('截图保存失败：未返回保存位置。');
    }
    return savedLocation;
  }
}
