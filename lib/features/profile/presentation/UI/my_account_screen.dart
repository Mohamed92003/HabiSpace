import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../widgets/delete_my_account_widget.dart';
import '../widgets/profile_menu_card.dart';
import '../widgets/profile_menu_item.dart';
import '../../domain/entities/Profile_Entity.dart';

class MyAccountScreen extends StatelessWidget {
  final ProfileEntity? user;

  const MyAccountScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: BackButton(color: context.appTheme.titleText),
        title: Text(
          AppTexts.profileMyAccount,
          style: TextStyle(
            color: context.appTheme.titleText,
            fontSize: AppSizes.sp18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.h20),
        child: ProfileMenuCard(
          sectionTitle: AppTexts.profileAccountSetting,
          items: [
            ProfileMenuItem(
              icon: Icons.email_outlined,
              title: user?.email ?? '',
              onTap: null,
            ),
            ProfileMenuItem(
              icon: Icons.delete_outline_rounded,
              title: 'Delete Account',
              isDestructive: true,
              isLast: true,
              onTap: () => DeleteAccountPopup.show(context),
            ),
          ],
        ),
      ),
    );
  }
}
