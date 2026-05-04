import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../domain/entities/property_detail_entity.dart';

class DetailsFeatureGrid extends StatelessWidget {
  final PropertyDetailEntity property;

  const DetailsFeatureGrid({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final amenities = property.amenities;
    final List<(IconData, String)> features = [];

    if (amenities['bedrooms'] != null)
      features.add((
        Icons.bed_outlined,
        '${amenities['bedrooms']} ${AppTexts.bedrooms.tr()}',
      ));
    if (amenities['bathrooms'] != null)
      features.add((
        Icons.bathtub_outlined,
        '${amenities['bathrooms']} ${AppTexts.bathrooms.tr()}',
      ));
    if (amenities['area'] != null)
      features.add((
        Icons.square_foot_outlined,
        '${amenities['area']} ${AppTexts.sqft.tr()}',
      ));
    if (amenities['garages'] != null)
      features.add((
        Icons.garage_outlined,
        '${amenities["garages"]} ${AppTexts.garages.tr()}',
      ));
    if (amenities['kitchens'] != null)
      features.add((Icons.kitchen_outlined, AppTexts.kitchen.tr()));

    if (features.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSizes.w4,
      runSpacing: AppSizes.h6,
      children: features.map((f) {
        final index = features.indexOf(f);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(f.$1, size: AppSizes.h14, color: AppColors.textLightColor),
            SizedBox(width: AppSizes.w4),
            Text(
              f.$2,
              style: TextStyle(
                fontSize: AppSizes.sp11,
                color: AppColors.textSecondaryColor,
              ),
            ),
            SizedBox(width: AppSizes.w8),
            if (index < features.length - 1)
              Text(
                ' | ',
                style: TextStyle(
                  fontSize: AppSizes.sp11,
                  color: AppColors.borderColor,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}
