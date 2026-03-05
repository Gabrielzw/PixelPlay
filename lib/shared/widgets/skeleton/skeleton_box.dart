import 'package:flutter/material.dart';

const double kSkeletonRadius = 12;

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(kSkeletonRadius),
    ),
  });

  @override
  Widget build(BuildContext context) {
    final fill = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: fill, borderRadius: borderRadius),
    );
  }
}
