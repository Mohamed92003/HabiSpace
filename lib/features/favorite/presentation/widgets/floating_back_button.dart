
import 'package:flutter/material.dart';
import '../../../../core/utils/app_sizes.dart';

class FloatingBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: AppSizes.w40,
        height: AppSizes.h40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.arrow_back, color: Colors.black, size: AppSizes.sp20),
      ),
    );
  }
}
