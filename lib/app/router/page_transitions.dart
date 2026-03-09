import 'package:flutter/material.dart';

import '../../features/settings/domain/page_transition_type.dart';

const Duration kPageTransitionDuration = Duration(milliseconds: 300);

Route<T> buildPageTransitionRoute<T>({
  required WidgetBuilder builder,
  required PageTransitionType type,
  RouteSettings? settings,
  Curve curve = Curves.easeInOut,
  Alignment alignment = Alignment.center,
  Duration duration = kPageTransitionDuration,
  bool fullscreenDialog = false,
}) {
  final routeDuration = type == PageTransitionType.none
      ? Duration.zero
      : duration;

  return PageRouteBuilder<T>(
    settings: settings,
    fullscreenDialog: fullscreenDialog,
    transitionDuration: routeDuration,
    reverseTransitionDuration: routeDuration,
    pageBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return builder(context);
        },
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );
          final curvedSecondaryAnimation = CurvedAnimation(
            parent: secondaryAnimation,
            curve: curve,
          );

          return buildTransitionWidget(
            type: type,
            child: child,
            animation: curvedAnimation,
            secondaryAnimation: curvedSecondaryAnimation,
            alignment: alignment,
          );
        },
  );
}

Widget buildTransitionWidget({
  required PageTransitionType type,
  required Widget child,
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Alignment alignment,
}) {
  return switch (type) {
    PageTransitionType.none => child,
    PageTransitionType.rightToLeftCupertino => _buildCupertinoSlide(
      child: child,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      enterOffset: const Offset(1.0, 0.0),
      exitOffset: const Offset(-0.3, 0.0),
    ),
    PageTransitionType.rightToLeft => _buildSlide(
      child: child,
      animation: animation,
      begin: const Offset(1.0, 0.0),
    ),
    PageTransitionType.leftToRight => _buildSlide(
      child: child,
      animation: animation,
      begin: const Offset(-1.0, 0.0),
    ),
    PageTransitionType.leftToRightCupertino => _buildCupertinoSlide(
      child: child,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      enterOffset: const Offset(-1.0, 0.0),
      exitOffset: const Offset(0.3, 0.0),
    ),
    PageTransitionType.upToDown => _buildSlide(
      child: child,
      animation: animation,
      begin: const Offset(0.0, -1.0),
    ),
    PageTransitionType.downToUp => _buildSlide(
      child: child,
      animation: animation,
      begin: const Offset(0.0, 1.0),
    ),
    PageTransitionType.scale => ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: child,
    ),
    PageTransitionType.rotate => RotationTransition(
      turns: animation,
      alignment: alignment,
      child: child,
    ),
    PageTransitionType.size => Align(
      alignment: alignment,
      child: SizeTransition(sizeFactor: animation, child: child),
    ),
    PageTransitionType.rightToLeftWithFade => _buildSlideFade(
      child: child,
      animation: animation,
      begin: const Offset(1.0, 0.0),
    ),
    PageTransitionType.leftToRightWithFade => _buildSlideFade(
      child: child,
      animation: animation,
      begin: const Offset(-1.0, 0.0),
    ),
    PageTransitionType.upToDownWithFade => _buildSlideFade(
      child: child,
      animation: animation,
      begin: const Offset(0.0, -1.0),
    ),
    PageTransitionType.downToUpWithFade => _buildSlideFade(
      child: child,
      animation: animation,
      begin: const Offset(0.0, 0.5),
    ),
  };
}

Widget _buildCupertinoSlide({
  required Widget child,
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Offset enterOffset,
  required Offset exitOffset,
}) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset.zero,
      end: exitOffset,
    ).animate(secondaryAnimation),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: enterOffset,
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}

Widget _buildSlide({
  required Widget child,
  required Animation<double> animation,
  required Offset begin,
}) {
  return SlideTransition(
    position: Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
    child: child,
  );
}

Widget _buildSlideFade({
  required Widget child,
  required Animation<double> animation,
  required Offset begin,
}) {
  return SlideTransition(
    position: Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
    child: FadeTransition(opacity: animation, child: child),
  );
}
