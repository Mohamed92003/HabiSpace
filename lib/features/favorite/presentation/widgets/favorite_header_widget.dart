import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../../core/utils/app_sizes.dart';

class FavoriteHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback onEdit;
  final bool isEditMode;

  const FavoriteHeaderWidget({
    super.key,
    this.title = AppTexts.yourFavorite,
    this.onBack,
    required this.onEdit,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w16, vertical: AppSizes.h12),
      child: Row(
        children: [
          if (canGoBack)
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.only(right: AppSizes.w12),
                child: Icon(Icons.arrow_back, size: AppSizes.sp24, color: Colors.black),
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: AppSizes.sp20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Text(
              isEditMode ? AppTexts.done.tr() : AppTexts.edit.tr(),
              style: TextStyle(
                fontSize: AppSizes.sp15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2BBFB3),
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF2BBFB3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
