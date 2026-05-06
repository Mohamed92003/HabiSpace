import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/shared/custom_svg.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../profile/presentation/Cubit/cubit/profile_cubit.dart';
import 'header_icon_button.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w20,
        vertical: AppSizes.h10,
      ),
      child: Row(
        children: [
          CustomSvgImage(path: 'assets/icons/locat_icon.svg'),
          SizedBox(width: AppSizes.w10),
          Expanded(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final user = state is ProfileLoaded && state.profile.isNotEmpty
                    ? state.profile.first
                    : null;

                final hasLocation =
                    user?.location != null && user!.location.isNotEmpty;

                return GestureDetector(
                  onTap: () {
                    if (user == null) {
                      context.read<ProfileCubit>().getProfile();
                      return;
                    }
                    context.pushNamed(
                      AppRoutes.updateProfile,
                      extra: {
                        'user': user,
                        'profileCubit': context.read<ProfileCubit>(),
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTexts.locationLabel.tr(),
                        style: TextStyle(
                          fontSize: AppSizes.sp12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLightColor,
                        ),
                      ),
                      SizedBox(height: AppSizes.h2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              hasLocation
                                  ? user.location
                                  : AppTexts.locationPlaceholder.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppSizes.sp14,
                                fontWeight: FontWeight.w600,
                                color: hasLocation
                                    ? AppColors.black
                                    : AppColors.textLightColor,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.w4),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: AppSizes.sp16,
                            color: AppColors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(width: AppSizes.w8),
          HeaderIconButton(
            path: 'assets/icons/notifi_icon.svg',
            onTap: () => context.pushNamed(AppRoutes.notifications),
            width: AppSizes.w20,
            height: AppSizes.h20,
          ),
          SizedBox(width: AppSizes.w12),
          HeaderIconButton(
            path: 'assets/icons/chat_icon.svg',
            onTap: () => context.pushNamed(AppRoutes.conversations),
            width: AppSizes.w20,
            height: AppSizes.h20,
          ),
        ],
      ),
    );
  }
}
