import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  final bool isLast;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    this.isDestructive = false,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : context.appTheme.titleText;
    final iconColor = isDestructive
        ? AppColors.error
        : context.appTheme.titleText;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.r14),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w16,
              vertical: AppSizes.h14,
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
                      color: color,
                    ),
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppSizes.sp15,
                    color: isDestructive
                        ? AppColors.error
                        : context.appTheme.subtleText,
                  ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 0.8,
            indent: 52,
            color: context.appTheme.divider,
          ),
      ],
    );
  }
}
