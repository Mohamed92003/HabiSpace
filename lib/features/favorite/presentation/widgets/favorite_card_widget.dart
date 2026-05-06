import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:habispace/features/favorite/presentation/widgets/property_image_widget.dart';
import 'package:habispace/features/favorite/presentation/widgets/type_badge_widget.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../favorite/domain/entities/favorite_property_entity.dart';
import 'amenity_chip_widget.dart';
import '../../../../core/utils/app_sizes.dart';

class FavoriteCardWidget extends StatelessWidget {
  final FavoritePropertyEntity property;
  final VoidCallback? onTap;
  final VoidCallback onFavoriteTap;

  const FavoriteCardWidget({
    super.key,
    required this.property,
    this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ext.cardBg,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          boxShadow: [
            BoxShadow(
              color: ext.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardImage(property: property),
            _CardContent(property: property, onFavoriteTap: onFavoriteTap),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  final FavoritePropertyEntity property;
  const _CardImage({required this.property});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PropertyImageWidget(
          imageUrl: property.images.isNotEmpty ? property.images.first : null,
          height: AppSizes.h200,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.r16),
          ),
        ),
        Positioned(
          top: AppSizes.h12,
          left: AppSizes.w12,
          child: TypeBadgeWidget(label: property.type),
        ),
      ],
    );
  }
}

class _CardContent extends StatelessWidget {
  final FavoritePropertyEntity property;
  final VoidCallback onFavoriteTap;
  const _CardContent({required this.property, required this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(title: property.title, onFavoriteTap: onFavoriteTap),
          SizedBox(height: AppSizes.h8),
          _LocationRow(address: property.address, distance: property.distance),
          SizedBox(height: AppSizes.h10),
          AmenitiesWrap(property: property),
          SizedBox(height: AppSizes.h12),
          _PriceRatingRow(price: property.price, rating: property.rating),
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onFavoriteTap;
  const _TitleRow({required this.title, required this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSizes.sp16,
              fontWeight: FontWeight.bold,
              color: ext.titleText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: AppSizes.w8),
        GestureDetector(
          onTap: onFavoriteTap,
          child: Icon(Icons.star, color: ext.starColor, size: AppSizes.sp26),
        ),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  final String address;
  final String distance;
  const _LocationRow({required this.address, required this.distance});

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: AppSizes.sp15,
          color: ext.locationIconColor,
        ),
        SizedBox(width: AppSizes.w4),
        Expanded(
          child: Text(
            address,
            style: TextStyle(fontSize: AppSizes.sp12, color: ext.subtleText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (distance.isNotEmpty) ...[
          SizedBox(width: AppSizes.w8),
          Container(width: 1, height: 12, color: ext.divider),
          SizedBox(width: AppSizes.w8),
          Icon(
            Icons.near_me_outlined,
            size: AppSizes.sp14,
            color: ext.locationIconColor,
          ),
          SizedBox(width: AppSizes.w4),
          Text(
            distance,
            style: TextStyle(fontSize: AppSizes.sp12, color: ext.subtleText),
          ),
        ],
      ],
    );
  }
}

class _PriceRatingRow extends StatelessWidget {
  final String price;
  final double rating;
  const _PriceRatingRow({required this.price, required this.rating});

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '\$$price',
                style: TextStyle(
                  fontSize: AppSizes.sp18,
                  fontWeight: FontWeight.bold,
                  color: ext.titleText,
                ),
              ),
              TextSpan(
                text: ' ${AppTexts.perMonth.tr()}',
                style: TextStyle(
                  fontSize: AppSizes.sp13,
                  color: ext.subtleText,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        if (rating > 0)
          Row(
            children: [
              Icon(Icons.star, color: ext.starColor, size: AppSizes.sp18),
              SizedBox(width: AppSizes.w4),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: AppSizes.sp14,
                  fontWeight: FontWeight.w600,
                  color: ext.bodyText,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
