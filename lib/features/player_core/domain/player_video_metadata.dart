import 'package:flutter/foundation.dart';

enum PlayerVideoOrientation { unknown, portrait, landscape, square }

@immutable
class PlayerVideoMetadata {
  final int? width;
  final int? height;
  final int rotationDegrees;

  const PlayerVideoMetadata({
    this.width,
    this.height,
    this.rotationDegrees = 0,
  });

  PlayerVideoOrientation get orientation {
    final rawWidth = width;
    final rawHeight = height;
    if (rawWidth == null || rawHeight == null) {
      return PlayerVideoOrientation.unknown;
    }
    if (rawWidth <= 0 || rawHeight <= 0) {
      return PlayerVideoOrientation.unknown;
    }

    final normalizedRotation = _normalizeRotation(rotationDegrees);
    final shouldSwapDimensions = normalizedRotation % 180 != 0;
    final displayWidth = shouldSwapDimensions ? rawHeight : rawWidth;
    final displayHeight = shouldSwapDimensions ? rawWidth : rawHeight;

    if (displayWidth == displayHeight) {
      return PlayerVideoOrientation.square;
    }
    if (displayHeight > displayWidth) {
      return PlayerVideoOrientation.portrait;
    }
    return PlayerVideoOrientation.landscape;
  }

  int _normalizeRotation(int value) {
    final normalizedValue = value % 360;
    if (normalizedValue < 0) {
      return normalizedValue + 360;
    }
    return normalizedValue;
  }
}
