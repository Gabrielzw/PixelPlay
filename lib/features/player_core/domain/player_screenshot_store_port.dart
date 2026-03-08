import 'dart:typed_data';

abstract interface class PlayerScreenshotStorePort {
  Future<String> saveScreenshot(Uint8List bytes);
}
