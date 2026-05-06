import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../domain/entities/property_detail_entity.dart';

class DetailsAppBar extends StatelessWidget {
  final double blurAmount;
  final Color bgColor;
  final Color iconColor;
  final bool isGlass;
  // passed from DetailsView once state is DetailsLoaded
  final PropertyDetailEntity? property;

  const DetailsAppBar({
    super.key,
    required this.blurAmount,
    required this.bgColor,
    required this.iconColor,
    required this.isGlass,
    this.property,
  });

  // void _onShare() {
  //   if (property == null) return;
  //   final link = 'https://real.newcinderella.online/details/${property!.slug}';
  //   Share.share(
  //     '${property!.title}\n$link',
  //     subject: property!.title,
  //   );
  // }
   void _onShare(){
    final link = 'https://real.newcinderella.online/details/${property!.slug}';
    Share.share(
    '${property!.title}\n$link',
    subject: property!.title,
  );
   }
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          color: bgColor,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w16,
                vertical: AppSizes.h10,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: DetailsAppBarButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      color: iconColor,
                      isGlass: isGlass,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        AppTexts.propertyDetail.tr(),
                        style: TextStyle(
                          color: AppColors.secondBlack,
                          fontSize: AppSizes.sp16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _onShare,
                    behavior: HitTestBehavior.opaque,
                    child: DetailsAppBarButton(
                      icon: Icons.share_rounded,
                      color: iconColor,
                      isGlass: isGlass,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsAppBarButton extends StatelessWidget {
  const DetailsAppBarButton({
    super.key,
    required this.icon,
    required this.color,
    required this.isGlass,
  });

  final IconData icon;
  final Color color;
  final bool isGlass;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: isGlass
            ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: AppSizes.w36,
          height: AppSizes.h36,
          decoration: BoxDecoration(
            color: isGlass
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: isGlass
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1,
                  )
                : null,
          ),
          child: Icon(icon, size: AppSizes.h18, color: color),
        ),
      ),
    );
  }
}
