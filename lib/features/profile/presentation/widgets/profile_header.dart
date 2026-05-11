import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habispace/features/profile/presentation/widgets/profile_avatar.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';

class ProfileHeaderSliver extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final int imageVersion;

  const ProfileHeaderSliver({
    super.key,
    this.imageUrl,
    required this.name,
    this.imageVersion = 0,
  });

  static const String _fallbackCover =
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800';

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSizes.h290,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: _fallbackCover,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Container(color: Colors.grey.shade300),
              ),
            ),
            Positioned(
              bottom: AppSizes.h16,
              left: AppSizes.w20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSizes.h4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ProfileAvatar(
                      imageUrl: imageUrl,
                      name: name,
                      radius: AppSizes.h50,
                      showBorder: false,
                      cacheVersion: imageVersion,
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
