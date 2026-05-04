
import 'package:flutter/material.dart';

import '../../domain/entities/favorite_property_entity.dart';

class DetailsLocationRow extends StatelessWidget {
  final FavoritePropertyEntity property;
  const DetailsLocationRow({required this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined,
            size: 16, color: Color(0xFF2BBFB3)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            property.address,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
