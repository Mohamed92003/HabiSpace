import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habispace/core/error/app_exception.dart';
import 'package:habispace/core/router/app_router.dart';
import 'package:habispace/core/shared/error_view.dart';
import 'package:habispace/core/shared/profile_skelton.dart';
import 'package:habispace/core/shared/skelton/shimmer.dart';
import 'package:habispace/core/shared/skelton/skelton_widget.dart';
import 'package:habispace/core/theme/theme_cubit.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/core/utils/app_texts.dart';
import 'package:habispace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import 'package:habispace/features/profile/presentation/widgets/delete_my_account_widget.dart';
import '../../../../core/utils/app_sizes.dart';
import '../widgets/build_switch_tile.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_card.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_menu_item_widget.dart';

List<Widget> profileViewSlivers(BuildContext context, ProfileState state) {
  if (state is ProfileInitial || state is ProfileLoading) {
    return [
        SliverToBoxAdapter(
          child: AppSkeleton(isLoading: true, skeleton: ProfileSkeleton(), child: SkeletonWidget()),
        )
    ];
  }

  if (state is ProfileError) {
    return [
      SliverErrorView(
        message: state.message,
        type: AppExceptionType.unknown,
        onRetry: () => context.read<ProfileCubit>().getProfile(),
      ),
    ];
  }

  if (state is ProfileLoaded) {
    final user = state.profile.isNotEmpty ? state.profile.first : null;

    return [
      ProfileHeaderSliver(imageUrl: user?.image, name: user?.name ?? ''),
      SliverToBoxAdapter(
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.h16),
                Text(
                  user?.name ?? AppTexts.profileUserName.tr(),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondBlack,
                  ),
                ),
                SizedBox(height: AppSizes.h6),
                Text(
                  user?.location.isNotEmpty == true
                      ? user!.location
                      : AppTexts.profileNoLocation.tr(),
                  style: TextStyle(
                    color: AppColors.textSecondaryColor,
                    fontSize: AppSizes.sp15,
                  ),
                ),
                SizedBox(height: AppSizes.h24),
                ProfileMenuCard(
                  sectionTitle: AppTexts.profileAccountSetting.tr(),
                  items: [
                    ProfileMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: AppTexts.profilePersonalInfo.tr(),
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.updateProfile,
                          extra: {
                            'user': user,
                            'profileCubit': context.read<ProfileCubit>(),
                          },
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.manage_accounts_outlined,
                      title: AppTexts.profileMyAccount.tr(),
                      isLast: true,
                      onTap: () => DeleteAccountPopup.show(context),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.h16),

                ProfileMenuCard(
                  sectionTitle: AppTexts.profileSettingSecurity.tr(),
                  items: [
                    ProfileMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: AppTexts.profileChangePassword.tr(),
                      onTap: () {
                        context.pushNamed(AppRoutes.changePassword);
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: AppTexts.profileNotificationPref.tr(),
                      onTap: () {
                        context.pushNamed(AppRoutes.notifications);
                      },
                    ),
                    ProfileMenuItemWidget(
                      child: BlocBuilder<ThemeCubit, ThemeMode>(
                        builder: (context, themeMode) {
                          final isDark = themeMode == ThemeMode.dark;
                          return buildSwitchTile(
                            icon: isDark
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            iconColor: isDark
                                ? Colors.amber
                                : Colors.grey.shade600,
                            title: isDark
                                ? AppTexts.profileDarkMode.tr()
                                : AppTexts.profileLightMode.tr(),
                            trailing: Switch(
                              value: isDark,
                              activeThumbColor: AppColors.blue,
                              onChanged: (_) =>
                                  context.read<ThemeCubit>().toggleTheme(),
                            ),
                          );
                        },
                      ),
                    ),
                    ProfileMenuItemWidget(
                      isLast: true,
                      child: Builder(
                        builder: (context) {
                          final isArabic = context.locale.languageCode == 'ar';
                          return buildSwitchTile(
                            icon: Icons.language_outlined,
                            iconColor: Colors.blueGrey,
                            title: AppTexts.profileLanguage.tr(),
                            trailing: GestureDetector(
                              onTap: () => context.setLocale(
                                isArabic
                                    ? const Locale('en')
                                    : const Locale('ar'),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.w12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade50,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.r20,
                                  ),
                                  border: Border.all(
                                    color: Colors.blueGrey.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isArabic ? '🇸🇦' : '🇺🇸',
                                      style: TextStyle(fontSize: AppSizes.sp15),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      isArabic ? 'العربية' : 'English',
                                      style: TextStyle(
                                        fontSize: AppSizes.sp13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.h16),
                ProfileMenuCard(
                  items: [
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      title: AppTexts.profilelogout.tr(),
                      isDestructive: true,
                      isLast: true,
                      onTap: () {
                        context.read<ProfileCubit>().logOutProfile();
                        context.pushReplacement(AppRoutes.login);
                      },
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.h100),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  return [
    SliverFillRemaining(
      child: Center(child: Text(AppTexts.profileSomethingWrong.tr())),
    ),
  ];
}
