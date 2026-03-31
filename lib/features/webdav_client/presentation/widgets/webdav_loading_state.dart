import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WebDavLoadingState extends StatelessWidget {
  const WebDavLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: LoadingAnimationWidget.progressiveDots(
        color: colorScheme.primary,
        size: 36,
      ),
    );
  }
}
