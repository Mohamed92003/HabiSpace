import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';

class ProfileMenuCard extends StatelessWidget {
  final String? sectionTitle;
  final List<Widget> items;
  const ProfileMenuCard({this.sectionTitle, required this.items});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null)
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.h8),
            child: Text(
              sectionTitle!,
              style: TextStyle(
                color: AppColors.textSecondaryColor,
                fontSize: AppSizes.sp14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.r14),
            border: Border.all(color: AppColors.borderColor, width: 0.8),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}
