import 'package:flutter/material.dart';
import 'package:habispace/core/utils/app_sizes.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.w16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
   
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 150, height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
              Row(children: [
                CircleAvatar(backgroundColor: Colors.white, radius: 20),
                SizedBox(width: 8),
                CircleAvatar(backgroundColor: Colors.white, radius: 20),
              ]),
            ],
          ),
          SizedBox(height: AppSizes.h24),

          // Search Bar Skeleton
          Container(height: 55, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30))),
          SizedBox(height: AppSizes.h24),

          // Categories Skeleton (الكبسولات)
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (_, __) => Container(
                width: 80,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
          SizedBox(height: AppSizes.h24),

          // Title Skeleton (Best Offers)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 100, height: 20, color: Colors.white),
              Container(width: 50, height: 15, color: Colors.white),
            ],
          ),
          SizedBox(height: AppSizes.h16),

          // Cards List Skeleton
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => _buildCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCardSkeleton() {
  return Container(
    width: AppSizes.w200, // نفس عرض الكارت في التصميم
    margin: EdgeInsets.only(right: AppSizes.w16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.r20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // مكان الصورة
        Container(
          height: AppSizes.h150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.r20),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppSizes.h12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 120, height: 15, color: Colors.white), // العنوان
              SizedBox(height: 8),
              Container(width: 80, height: 12, color: Colors.white),  // الموقع
            ],
          ),
        ),
      ],
    ),
  );
}