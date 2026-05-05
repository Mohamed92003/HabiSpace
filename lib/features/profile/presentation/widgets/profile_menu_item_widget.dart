
import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final Widget child;
  final bool isLast;

  const ProfileMenuItemWidget({required this.child, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        if (!isLast)
          Divider(
            height: 1,
            thickness: 0.8,
            indent: 52,
            color: AppColors.borderColor,
          ),
      ],
    );
  }
}
