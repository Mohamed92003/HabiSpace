import 'package:flutter/material.dart';
import 'package:habispace/core/shared/skelton/skelton_widget.dart';
import '../../../../core/utils/app_sizes.dart'; // تأكد من المسار الصحيح عندك
 
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (Cover + Profile Image)
          Stack(
            clipBehavior: Clip.none,
            children: [
              // الـ Cover Image
              const SkeletonWidget(
                height: 200,
                width: double.infinity,
                borderRadius: 0,
              ),
              // صورة البروفايل (الباندا)
              Positioned(
                bottom: -50,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const SkeletonWidget(
                    height: 100,
                    width: 100,
                    borderRadius: 50, // عشان تطلع دايرة كاملة
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),

          // 2. Profile Info (Name & Location)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonWidget(height: 25, width: 120), // الاسم (apdooo)
                const SizedBox(height: 10),
                const SkeletonWidget(height: 15, width: 100), // الموقع (No location set)
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 3. Settings Groups
          _buildSettingsGroupSkeleton("Account Setting"),
          const SizedBox(height: 20),
          _buildSettingsGroupSkeleton("Setting & Security"),
          
          // Log out Button
          Padding(
            padding: EdgeInsets.all(AppSizes.w20),
            child: const SkeletonWidget(height: 50, width: double.infinity, borderRadius: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroupSkeleton(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.w20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonWidget(height: 15, width: 80), // العنوان الصغير (Account Setting)
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.r14),
            ),
            child: Column(
              children: List.generate(2, (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const SkeletonWidget(height: 24, width: 24, borderRadius: 5), // Icon
                    const SizedBox(width: 15),
                    const SkeletonWidget(height: 15, width: 150), // Text
                    const Spacer(),
                    const SkeletonWidget(height: 15, width: 15, borderRadius: 5), // Arrow
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}