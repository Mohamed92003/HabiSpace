import 'package:flutter/material.dart';
import 'package:habispace/core/theme/app_theme.dart';

class SkeletonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;

  const SkeletonWidget({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.appTheme.imagePlaceholder,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    );
  }
}
