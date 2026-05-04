
import 'package:flutter/material.dart';

import '../../domain/entities/favorite_property_entity.dart';
import 'amenity_chip_widget.dart';
import 'details_location_row.dart';
import 'details_price_row.dart';
import 'details_title_row.dart';

class DetailsContent extends StatelessWidget {
  final FavoritePropertyEntity property;
  const DetailsContent({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsTitleRow(property: property),
          const SizedBox(height: 10),
          DetailsLocationRow(property: property),
          const SizedBox(height: 16),
          AmenitiesWrap(property: property),
          const SizedBox(height: 20),
          DetailsPriceRow(property: property),
        ],
      ),
    );
  }
}
