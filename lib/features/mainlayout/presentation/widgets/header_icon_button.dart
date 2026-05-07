import 'package:flutter/material.dart';

import '../../../../core/shared/custom_svg.dart';
import '../../../../core/utils/app_color.dart';
 
// ignore: must_be_immutable
class HeaderIconButton extends StatelessWidget {
   HeaderIconButton({
    super.key,
    required this.path,
    required this.onTap,
    required this.width,
    required this.height,
    this.color = AppColors.light,
  });
  final String path;
  final Function() onTap;
  final double width;
  final double height ;
  Color color ;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: CustomSvgImage(
          path: path,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
