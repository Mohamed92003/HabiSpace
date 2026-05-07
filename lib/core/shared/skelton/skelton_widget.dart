import 'package:flutter/material.dart';

class SkeletonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;

  const SkeletonWidget({
    super.key, 
    this.width, 
    this.height, 
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
         color: Colors.white, 
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    );
  }
}