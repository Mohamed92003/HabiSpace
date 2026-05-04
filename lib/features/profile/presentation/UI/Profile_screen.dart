import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habispace/core/error/app_exception.dart';
import 'package:habispace/core/router/app_router.dart';
import 'package:habispace/core/shared/error_view.dart';
import 'package:habispace/core/theme/theme_cubit.dart';
import 'package:habispace/core/utils/app_texts.dart';
import 'package:habispace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import 'package:habispace/features/profile/presentation/UI/widgets/SectionTitle.dart';
import 'package:habispace/features/profile/presentation/UI/widgets/profile_avatar.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                user?.name ?? AppTexts.profileUserName.tr(),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                user?.location.isNotEmpty == true
                    ? user!.location
                    : AppTexts.profileNoLocation.tr(),
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 15),

              buildSectionTitle(AppTexts.profileAccountSetting.tr()),
              buildMenuItem(Icons.person_outline, AppTexts.profilePersonalInfo.tr()),
              buildMenuItem(Icons.key_outlined, AppTexts.profileMyAccount.tr()),

              const SizedBox(height: 20),
              buildSectionTitle(AppTexts.profilePayment.tr()),
              buildMenuItem(Icons.credit_card_outlined, AppTexts.profilePaymentMethod.tr()),

              const SizedBox(height: 20),
              buildSectionTitle(AppTexts.profileSettingSecurity.tr()),
              buildMenuItem(Icons.lock_outline, AppTexts.profileChangePassword.tr()),
              buildMenuItem(
                Icons.notifications_none_outlined,
                AppTexts.profileNotificationPref.tr(),
              ),

              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  final isDark = themeMode == ThemeMode.dark;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: isDark ? Colors.amber : Colors.grey.shade600,
                    ),
                    title: Text(
                      isDark
                          ? AppTexts.profileDarkMode.tr()
                          : AppTexts.profileLightMode.tr(),
                      style: const TextStyle(fontSize: 15),
                    ),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                    ),
                  );
                },
              ),

              Builder(
                builder: (context) {
                  final isArabic = context.locale.languageCode == 'ar';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.language, color: Colors.blueGrey),
                    title: Text(
                      AppTexts.profileLanguage.tr(),
                      style: const TextStyle(fontSize: 15),
                    ),
                    trailing: GestureDetector(
                      onTap: () => context.setLocale(
                        isArabic ? const Locale('en') : const Locale('ar'),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blueGrey.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isArabic ? '🇸🇦' : '🇺🇸',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
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

              buildMenuItem(
                Icons.delete_outline,
                AppTexts.profilelogout.tr(),
                isDestructive: true,
                onTap: () {
                  context.read<ProfileCubit>().deleteProfile();
                  context.pushReplacement(AppRoutes.login);
                  },
              ),

              const SizedBox(height: 100),
            ],
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

class _ProfileHeaderSliver extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const _ProfileHeaderSliver({this.imageUrl, required this.name});

  static const String _fallbackImage =
      'https://i.pinimg.com/474x/7a/24/75/7a247579a370259119ed42b4bdddeea1.jpg';

  @override
  Widget build(BuildContext context) {
    final coverImage =
        imageUrl?.isNotEmpty == true ? imageUrl! : _fallbackImage;

    return SliverAppBar(
      expandedHeight: 240,
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: false,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Image.network(
                coverImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
              ),
            ),
            Positioned(
              top: 110,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ProfileAvatar(
                  imageUrl: imageUrl,
                  name: name,
                  radius: 50,
                  showBorder: false,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
