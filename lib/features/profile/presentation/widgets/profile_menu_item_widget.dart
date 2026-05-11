import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
            color: context.appTheme.divider,
          ),
      ],
    );
  }
}
