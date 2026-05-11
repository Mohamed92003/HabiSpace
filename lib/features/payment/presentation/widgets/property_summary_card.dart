import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habispace/core/theme/app_theme.dart';
import 'package:habispace/features/details/domain/entities/property_detail_entity.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/core/utils/app_sizes.dart';

class PropertySummaryCard extends StatelessWidget {
  final PropertyDetailEntity property;

  const PropertySummaryCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.r8),
            child: Container(
              width: AppSizes.w56,
              height: AppSizes.h60,
              color: context.appTheme.imagePlaceholder,
              child: property.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: property.images.first,
                      width: AppSizes.w56,
                      height: AppSizes.h60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Icon(Icons.home, color: context.appTheme.subtleText),
                    )
                  : Icon(Icons.home, color: context.appTheme.subtleText),
            ),
          ),
          SizedBox(width: AppSizes.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: context.appTheme.titleText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.h4),
                Text(
                  property.address,
                  style: TextStyle(
                    fontSize: AppSizes.sp12,
                    color: context.appTheme.subtleText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.h8),
                Row(
                  children: [
                    Icon(Icons.star, size: AppSizes.h14, color: Colors.amber),
                    SizedBox(width: AppSizes.w4),
                    Text(
                      '${(property.rating ?? 0.0).toStringAsFixed(1)} Rating',
                      style: TextStyle(
                        fontSize: AppSizes.sp12,
                        fontWeight: FontWeight.w500,
                        color: context.appTheme.titleText,
                      ),
                    ),
                    SizedBox(width: AppSizes.w8),
                    Text(
                      '(${property.reviewsCount} Reviews)',
                      style: TextStyle(
                        fontSize: AppSizes.sp12,
                        color: context.appTheme.subtleText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: AppSizes.r16,
            backgroundColor: AppColors.blue,
            child: Text(
              property.agent.user.name.isNotEmpty
                  ? property.agent.user.name[0].toUpperCase()
                  : 'A',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSizes.sp14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
