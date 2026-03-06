const int _bytesPerKB = 1024;
const int _bytesPerMB = _bytesPerKB * 1024;
const int _bytesPerGB = _bytesPerMB * 1024;

const double _sizeNoDecimalThreshold = 10;
const int _sizeDecimalPlacesLarge = 0;
const int _sizeDecimalPlacesSmall = 1;

const String _trailingZeroDecimal = '.0';
const int _trailingZeroDecimalLength = 2;

const int _twoDigitsWidth = 2;
const String _twoDigitsPadChar = '0';

String formatVideoDuration(Duration duration) {
  if (duration.isNegative) {
    throw RangeError('duration must be >= 0: $duration');
  }

  final totalSeconds = duration.inSeconds;
  final hours = totalSeconds ~/ Duration.secondsPerHour;
  final minutes =
      (totalSeconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;
  final seconds = totalSeconds % Duration.secondsPerMinute;

  if (hours > 0) {
    return '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }
  return '${_twoDigits(minutes)}:${_twoDigits(seconds)}';
}

String formatResolution({required int width, required int height}) {
  if (width <= 0) {
    throw RangeError('width must be > 0: $width');
  }
  if (height <= 0) {
    throw RangeError('height must be > 0: $height');
  }
  return '$width×$height';
}

String formatFileSize(int bytes) {
  if (bytes < 0) {
    throw RangeError('bytes must be >= 0: $bytes');
  }

  if (bytes >= _bytesPerGB) {
    return _formatSize(bytes / _bytesPerGB, 'GB');
  }
  if (bytes >= _bytesPerMB) {
    return _formatSize(bytes / _bytesPerMB, 'MB');
  }
  if (bytes >= _bytesPerKB) {
    return _formatSize(bytes / _bytesPerKB, 'KB');
  }
  return '$bytes B';
}

String formatChineseDateTime(DateTime value) {
  return '${value.year}年${value.month}月${value.day}日 '
      '${_twoDigits(value.hour)}:${_twoDigits(value.minute)}';
}

String _formatSize(double value, String unit) {
  final fixed = value >= _sizeNoDecimalThreshold
      ? value.toStringAsFixed(_sizeDecimalPlacesLarge)
      : value.toStringAsFixed(_sizeDecimalPlacesSmall);
  final text = fixed.endsWith(_trailingZeroDecimal)
      ? fixed.substring(0, fixed.length - _trailingZeroDecimalLength)
      : fixed;
  return '$text $unit';
}

String _twoDigits(int value) =>
    value.toString().padLeft(_twoDigitsWidth, _twoDigitsPadChar);
