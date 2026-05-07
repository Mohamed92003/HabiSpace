import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        color: Colors.white,
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
          // Property Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.r8),
            child: Container(
              width: AppSizes.w56,
              height: AppSizes.h60,
              color: Colors.grey.shade200,
              child: property.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: property.images.first,
                      width: AppSizes.w56,
                      height: AppSizes.h60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.home,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
            ),
          ),
          
          SizedBox(width: AppSizes.w12),
          
          // Property Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: AppSizes.h4),
                
                Text(
                  property.address,
                  style: TextStyle(
                    fontSize: AppSizes.sp12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: AppSizes.h8),
                
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: AppSizes.h14,
                      color: Colors.amber,
                    ),
                    SizedBox(width: AppSizes.w4),
                    Text(
                      '${property.rating?.toStringAsFixed(1) ?? '4.9'} Rating',
                      style: TextStyle(
                        fontSize: AppSizes.sp12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: AppSizes.w8),
                    Text(
                      '(${property.reviewsCount} Reviews)',
                      style: TextStyle(
                        fontSize: AppSizes.sp12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Agent Avatar
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