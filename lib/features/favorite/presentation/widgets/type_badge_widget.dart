import 'package:flutter/material.dart';
import '../../../../core/utils/app_sizes.dart';

class TypeBadgeWidget extends StatelessWidget {
  final String label;

  const TypeBadgeWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w10, vertical: AppSizes.h6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sell_outlined, size: AppSizes.sp14, color: Color(0xFF2BBFB3)),
          SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.sp12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
