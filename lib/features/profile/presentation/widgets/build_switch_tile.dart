import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_sizes.dart';

Widget buildSwitchTile({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required String title,
  required Widget trailing,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSizes.w16,
      vertical: AppSizes.h4,
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor, size: AppSizes.sp22),
        SizedBox(width: AppSizes.w14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSizes.sp15,
              fontWeight: FontWeight.w500,
              color: context.appTheme.titleText,
            ),
          ),
        ),
        trailing,
      ],
    ),
  );
}
