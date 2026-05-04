import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';

class DetailsBottomBar extends StatelessWidget {
  const DetailsBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: AppColors.light.withValues(alpha: 0.92),
          padding: EdgeInsets.fromLTRB(
            AppSizes.w18,
            AppSizes.h12,
            AppSizes.w18,
            AppSizes.h28,
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluelight,
                    foregroundColor: AppColors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.r14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h14),
                  ),
                  child: Text(
                    AppTexts.exploreIn360.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppSizes.sp14,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.light,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.r14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h14),
                  ),
                  child: Text(
                    AppTexts.bookACall.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppSizes.sp14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
