
import 'package:flutter/material.dart';

import '../../domain/entities/favorite_property_entity.dart';

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
                text: '\$${property.price}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const TextSpan(
                text: '/ month',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        if (property.rating > 0)
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 20),
              const SizedBox(width: 4),
              Text(
                property.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
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
