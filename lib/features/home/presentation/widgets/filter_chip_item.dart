import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';

class FilterChipItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:  Duration(milliseconds: 250),
        margin:  EdgeInsets.only(right: AppSizes.w10),
        padding:  EdgeInsets.symmetric(horizontal: AppSizes.w18, vertical: AppSizes.h12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blue
              : AppColors.bluelight,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.blue,
            fontSize: AppSizes.sp14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}