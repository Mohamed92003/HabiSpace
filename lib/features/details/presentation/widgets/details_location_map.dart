import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../../features/map/ui/property_map_view.dart';
import '../../domain/entities/property_detail_entity.dart';

class DetailsLocationMap extends StatelessWidget {
  final PropertyDetailEntity property;

  const DetailsLocationMap({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final hasLocation = property.latitude != null && property.longitude != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.locationAddress.tr(),
          style: TextStyle(
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w700,
            color: context.appTheme.titleText,
          ),
        ),
        SizedBox(height: AppSizes.h12),
        GestureDetector(
          onTap: hasLocation
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PropertyMapView(
                      latitude: property.latitude!,
                      longitude: property.longitude!,
                      title: property.title,
                      price: property.price,
                      address: property.address,
                      listingType: property.listingType,
                    ),
                  ),
                )
              : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: AppSizes.h160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                  color: context.appTheme.imagePlaceholder,
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset('assets/images/map.png', fit: BoxFit.cover),
              ),
              if (hasLocation)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w12,
                    vertical: AppSizes.h8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(AppSizes.r20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_full_rounded,
                        color: Colors.white,
                        size: AppSizes.sp14,
                      ),
                      SizedBox(width: AppSizes.w6),
                      Text(
                        'View on map',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.sp12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (property.address.isNotEmpty) ...[
          SizedBox(height: AppSizes.h8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: AppSizes.sp14,
                color: context.appTheme.subtleText,
              ),
              SizedBox(width: AppSizes.w4),
              Expanded(
                child: Text(
                  property.address,
                  style: TextStyle(
                    fontSize: AppSizes.sp13,
                    color: context.appTheme.subtleText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
