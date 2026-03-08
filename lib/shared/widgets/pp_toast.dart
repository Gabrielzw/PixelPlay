import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

const Duration _kToastShortDuration = Duration(milliseconds: 2000);
const Duration _kToastLongDuration = Duration(milliseconds: 3500);
const double _kToastBottomSpacing = 60;
const double _kToastHorizontalMargin = 20;
const double _kToastHorizontalPadding = 12;
const double _kToastVerticalPadding = 6;
const double _kToastBorderRadius = 24;
const double _kToastShadowBlurRadius = 10;
const double _kToastShadowOffsetY = 4;
const double _kToastBackgroundAlpha = 0.75;
const double _kToastShadowAlpha = 0.1;
const double _kToastIconSize = 16;
const double _kToastIconSpacing = 10;
const double _kToastFontSize = 14;
const double _kToastMaxWidth = 320;
const int _kToastMaxLines = 2;

class PPToast {
  PPToast._();

  static Future<void> show(
    String msg, {
    bool isLong = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return SmartDialog.showToast(
      '',
      alignment: Alignment.bottomCenter,
      displayTime: isLong ? _kToastLongDuration : _kToastShortDuration,
      displayType: SmartToastType.last,
      builder: (BuildContext context) {
        return _PPToastBody(msg: msg, icon: icon, iconColor: iconColor);
      },
    );
  }

  static Future<void> success(String msg) {
    return show(
      msg,
      icon: Icons.check_circle_rounded,
      iconColor: Colors.greenAccent,
    );
  }

  static Future<void> error(String msg) {
    return show(
      msg,
      icon: Icons.error_outline_rounded,
      iconColor: Colors.redAccent,
    );
  }

  static Future<void> warning(String msg) {
    return show(
      msg,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orangeAccent,
    );
  }

  static Future<void> showLoading({String msg = '\u52a0\u8f7d\u4e2d...'}) {
    return SmartDialog.showLoading(msg: msg);
  }

  static Future<void> dismissLoading() {
    return SmartDialog.dismiss(status: SmartStatus.loading);
  }
}

class _PPToastBody extends StatelessWidget {
  final String msg;
  final IconData? icon;
  final Color? iconColor;

  const _PPToastBody({
    required this.msg,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final double bottomMargin =
        MediaQuery.paddingOf(context).bottom + _kToastBottomSpacing;

    return Container(
      margin: EdgeInsets.fromLTRB(
        _kToastHorizontalMargin,
        0,
        _kToastHorizontalMargin,
        bottomMargin,
      ),
      constraints: const BoxConstraints(maxWidth: _kToastMaxWidth),
      padding: const EdgeInsets.symmetric(
        horizontal: _kToastHorizontalPadding,
        vertical: _kToastVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: _kToastBackgroundAlpha),
        borderRadius: BorderRadius.circular(_kToastBorderRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: _kToastShadowAlpha),
            blurRadius: _kToastShadowBlurRadius,
            offset: const Offset(0, _kToastShadowOffsetY),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, color: iconColor ?? Colors.white, size: _kToastIconSize),
            const SizedBox(width: _kToastIconSpacing),
          ],
          Flexible(
            child: Text(
              msg,
              textAlign: TextAlign.center,
              maxLines: _kToastMaxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: _kToastFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
