import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';

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
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              sectionTitle!,
              style: const TextStyle(
                color: AppColors.textSecondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor, width: 0.8),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}
