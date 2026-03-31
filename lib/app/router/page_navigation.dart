import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/settings/domain/page_transition_type.dart';
import '../../features/settings/domain/settings_controller.dart';
import 'page_transitions.dart';

Route<T> buildShellPageRoute<T>({
  required WidgetBuilder builder,
  RouteSettings? settings,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: kPageTransitionDuration,
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
          final settingsController = Get.find<SettingsController>();
          final transitionType =
              settingsController.settings.value.pageTransitionType;

          return buildTransitionWidget(
            type: transitionType,
            child: child,
            animation: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            secondaryAnimation: CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeInOut,
            ),
            alignment: Alignment.center,
          );
        },
  );
}

Route<T> buildConfiguredPageRoute<T>({
  required WidgetBuilder builder,
  PageTransitionType? transitionType,
  RouteSettings? settings,
  bool fullscreenDialog = false,
}) {
  final selectedType =
      transitionType ??
      Get.find<SettingsController>().settings.value.pageTransitionType;

  return buildPageTransitionRoute<T>(
    builder: builder,
    type: selectedType,
    settings: settings,
    fullscreenDialog: fullscreenDialog,
  );
}

Future<T?> pushRootPage<T>(
  BuildContext context,
  WidgetBuilder builder, {
  PageTransitionType? transitionType,
  RouteSettings? settings,
  bool fullscreenDialog = false,
}) {
  return Navigator.of(context, rootNavigator: true).push<T>(
    buildConfiguredPageRoute<T>(
      builder: builder,
      transitionType: transitionType,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    ),
  );
}
