import 'package:flutter/material.dart';
import 'package:habispace/core/theme/app_theme.dart';
import 'package:habispace/core/utils/app_sizes.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appTheme.imagePlaceholder;
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.w16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(backgroundColor: c, radius: 20),
                  SizedBox(width: 8),
                  CircleAvatar(backgroundColor: c, radius: 20),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSizes.h24),
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          SizedBox(height: AppSizes.h24),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (_, __) => Container(
                width: 80,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.h24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 100, height: 20, color: c),
              Container(width: 50, height: 15, color: c),
            ],
          ),
          SizedBox(height: AppSizes.h16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => _buildCardSkeleton(c),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCardSkeleton(Color c) {
  return Container(
    width: AppSizes.w200,
    margin: EdgeInsets.only(right: AppSizes.w16),
    decoration: BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(AppSizes.r20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AppSizes.h150,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(AppSizes.r20),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppSizes.h12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 120, height: 15, color: c),
              SizedBox(height: 8),
              Container(width: 80, height: 12, color: c),
            ],
          ),
        ),
      ],
    ),
  );
}
