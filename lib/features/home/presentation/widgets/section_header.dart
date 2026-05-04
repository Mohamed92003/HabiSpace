import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key,
  required this.title,
  this.onPressed
  });

  final String title;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: AppSizes.sp20,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(
                AppTexts.viewAll.tr(),
                style: TextStyle(
                  fontSize: AppSizes.sp14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
