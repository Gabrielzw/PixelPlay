part of 'player_controller.dart';

const String kPlayerScreenshotSuccessMessage = '截图成功，已保存到 Pictures/PixelPlay';
const String kPlayerScreenshotEmptyDataMessage = '截图失败：未获取到图像数据。';
const String kPlayerScreenshotErrorPrefix = '截图失败：';

extension PlayerControllerScreenshot on PlayerController {
  void captureScreenshot() {
    if (isCapturingScreenshot.value) {
      return;
    }

    unawaited(_captureScreenshot());
  }

  Future<void> _captureScreenshot() async {
    isCapturingScreenshot.value = true;
    try {
      final screenshotBytes = await playbackPort.captureScreenshot();
      if (screenshotBytes == null || screenshotBytes.isEmpty) {
        throw StateError(kPlayerScreenshotEmptyDataMessage);
      }

      await screenshotStore.saveScreenshot(screenshotBytes);
      toastMessage.value = const PlayerToastState(
        message: kPlayerScreenshotSuccessMessage,
        kind: PlayerToastKind.success,
      );
    } catch (error) {
      showInfoHud(_formatScreenshotError(error));
    } finally {
      isCapturingScreenshot.value = false;
    }
  }

  void clearToastMessage() {
    toastMessage.value = null;
  }

  String _formatScreenshotError(Object error) {
    final message = _cleanPlaybackError(error);
    if (message.startsWith(kPlayerScreenshotErrorPrefix)) {
      return message;
    }
    return '$kPlayerScreenshotErrorPrefix$message';
  }
}
