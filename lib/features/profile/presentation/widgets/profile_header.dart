import 'package:flutter/material.dart';
import 'package:habispace/features/profile/presentation/widgets/profile_avatar.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';

class ProfileHeaderSliver extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const ProfileHeaderSliver({this.imageUrl, required this.name});

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
              child: Image.network(
                _fallbackCover,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade300),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ProfileAvatar(
                      imageUrl: imageUrl,
                      name: name,
                      radius: AppSizes.h50,
                      showBorder: false,
                    ),
                  ),
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
