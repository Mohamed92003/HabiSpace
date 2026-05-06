import 'package:flutter/material.dart';

import '../../domain/entities/favorite_property_entity.dart';
import '../../../../core/utils/app_sizes.dart';

class DetailsTitleRow extends StatelessWidget {
  final FavoritePropertyEntity property;
  const DetailsTitleRow({required this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            property.title,
            style: TextStyle(
              fontSize: AppSizes.sp22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: AppSizes.w8),
        Icon(Icons.star, color: Color(0xFFFFC107), size: AppSizes.sp28),
      ],
    );
  }
}
