import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habispace/core/error/app_exception.dart';
import 'package:habispace/core/router/app_router.dart';
import 'package:habispace/core/shared/error_view.dart';
import 'package:habispace/core/theme/theme_cubit.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/core/utils/app_texts.dart';
import 'package:habispace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import '../../../../core/utils/app_sizes.dart';
import '../widgets/profile_avatar.dart';

List<Widget> profileViewSlivers(BuildContext context, ProfileState state) {
  if (state is ProfileInitial || state is ProfileLoading) {
    return [
      const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
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
      _ProfileHeaderSliver(imageUrl: user?.image, name: user?.name ?? ''),
      SliverToBoxAdapter(
        child: Container(
          color: AppColors.lightBackground,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: AppSizes.h16),
                Text(
                  user?.name ?? AppTexts.profileUserName.tr(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondBlack,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.location.isNotEmpty == true
                      ? user!.location
                      : AppTexts.profileNoLocation.tr(),
                  style: const TextStyle(
                    color: AppColors.textSecondaryColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                // Account Setting section
                _ProfileMenuCard(
                  sectionTitle: AppTexts.profileAccountSetting.tr(),
                  items: [
                    _ProfileMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: AppTexts.profilePersonalInfo.tr(),
                      onTap: (){
                        context.pushNamed(AppRoutes.updateProfile, extra: {
                          'user': user,
                          'profileCubit': context.read<ProfileCubit>(),
                        });
                      },

                    ),
                    _ProfileMenuItem(
                      icon: Icons.manage_accounts_outlined,
                      title: AppTexts.profileMyAccount.tr(),
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Payment section
                _ProfileMenuCard(
                  sectionTitle: AppTexts.profilePayment.tr(),
                  items: [
                    _ProfileMenuItem(
                      icon: Icons.credit_card_outlined,
                      title: AppTexts.profilePaymentMethod.tr(),
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Setting & Security section
                _ProfileMenuCard(
                  sectionTitle: AppTexts.profileSettingSecurity.tr(),
                  items: [
                    _ProfileMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: AppTexts.profileChangePassword.tr(),
                    ),
                    _ProfileMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: AppTexts.profileNotificationPref.tr(),
                    ),
                    _ProfileMenuItemWidget(
                      child: BlocBuilder<ThemeCubit, ThemeMode>(
                        builder: (context, themeMode) {
                          final isDark = themeMode == ThemeMode.dark;
                          return _buildSwitchTile(
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
                              activeColor: AppColors.blue,
                              onChanged: (_) =>
                                  context.read<ThemeCubit>().toggleTheme(),
                            ),
                          );
                        },
                      ),
                    ),
                    _ProfileMenuItemWidget(
                      isLast: true,
                      child: Builder(
                        builder: (context) {
                          final isArabic = context.locale.languageCode == 'ar';
                          return _buildSwitchTile(
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blueGrey.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isArabic ? '🇸🇦' : '🇺🇸',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      isArabic ? 'العربية' : 'English',
                                      style: const TextStyle(
                                        fontSize: 13,
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
                const SizedBox(height: 16),

                // Logout
                _ProfileMenuCard(
                  items: [
                    _ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      title: AppTexts.profilelogout.tr(),
                      isDestructive: true,
                      isLast: true,
                      onTap: () {
                        context.read<ProfileCubit>().deleteProfile();
                        context.pushReplacement(AppRoutes.login);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 100),
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

// ─── Header Sliver ────────────────────────────────────────────────────────────

class _ProfileHeaderSliver extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const _ProfileHeaderSliver({this.imageUrl, required this.name});

  static const String _fallbackCover =
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800';

  @override
  Widget build(BuildContext context) {
    const double coverHeight = 200;
    const double avatarRadius = 50;
    // Avatar sits mostly below the cover — only a small portion overlaps
    const double avatarOverlap = avatarRadius * 0.3;
    const double totalHeight = coverHeight + (avatarRadius * 2) - avatarOverlap;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover image — fills the full SizedBox
            Positioned.fill(
              child: Image.network(
                _fallbackCover,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade300),
              ),
            ),
            // Avatar with white border ring + edit badge on bottom-right
            Positioned(
              top: coverHeight - avatarOverlap,
              left: 20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // White ring + avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ProfileAvatar(
                      imageUrl: imageUrl,
                      name: name,
                      radius: avatarRadius,
                      showBorder: false,
                    ),
                  ),
                  // Edit icon badge — bottom-right corner
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Menu Card ────────────────────────────────────────────────────────────────

class _ProfileMenuCard extends StatelessWidget {
  final String? sectionTitle;
  final List<Widget> items;

  const _ProfileMenuCard({this.sectionTitle, required this.items});

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

// ─── Menu Item (icon + title + arrow) ─────────────────────────────────────────

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  final bool isLast;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.isDestructive = false,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.secondBlack;
    final iconColor = isDestructive ? AppColors.error : Colors.black87;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: isDestructive ? AppColors.error : Colors.grey.shade400,
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
            color: AppColors.borderColor,
          ),
      ],
    );
  }
}

// ─── Menu Item wrapper for custom trailing widgets ────────────────────────────

class _ProfileMenuItemWidget extends StatelessWidget {
  final Widget child;
  final bool isLast;

  const _ProfileMenuItemWidget({required this.child, this.isLast = false});

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

// ─── Helper for switch/language tiles ─────────────────────────────────────────

Widget _buildSwitchTile({
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
