import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';


Widget buildSwitchTile({
  required IconData icon,
  required Color iconColor,
  required String title,
  required Widget trailing,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.secondBlack,
            ),
          ),
        ),
        trailing,
      ],
    ),
  );
}


