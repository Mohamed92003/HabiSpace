import 'package:flutter/material.dart';

import '../../domain/entities/favorite_property_entity.dart';
import '../../../../core/utils/app_sizes.dart';

class DetailsPriceRow extends StatelessWidget {
  final FavoritePropertyEntity property;
  const DetailsPriceRow({required this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '\${property.price}',
                style: TextStyle(
                  fontSize: AppSizes.sp22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '/ month',
                style: TextStyle(
                  fontSize: AppSizes.sp14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        if (property.rating > 0)
          Row(
            children: [
              Icon(Icons.star, color: Color(0xFFFFC107), size: AppSizes.sp20),
              SizedBox(width: AppSizes.w4),
              Text(
                property.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: AppSizes.sp16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
