
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../favorite/domain/entities/favorite_property_entity.dart';

class AmenityChipWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const AmenityChipWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0EC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class AmenitiesWrap extends StatelessWidget {
  final FavoritePropertyEntity property;

  const AmenitiesWrap({super.key, required this.property});

  List<({IconData icon, String label})> _buildItems() {
    final items = <({IconData icon, String label})>[];

    if (property.bedrooms > 0) {
      items.add((
        icon: Icons.bed_outlined,
        label: '${property.bedrooms} Bedroom${property.bedrooms > 1 ? 's' : ''}',
      ));
    }
    if (property.bathrooms > 0) {
      items.add((
        icon: Icons.bathtub_outlined,
        label: '${property.bathrooms} Bathroom${property.bathrooms > 1 ? 's' : ''}',
      ));
    }

    for (final a in property.amenities) {
      final lower = a.toLowerCase();
      if (lower.contains('bedroom') || lower.contains('bathroom')) continue;
      items.add((icon: _iconFor(lower), label: a));
    }

    return items;
  }

  IconData _iconFor(String name) {
    if (name.contains('kitchen')) return Icons.kitchen_outlined;
    if (name.contains('lounge') || name.contains('living')) return Icons.weekend_outlined;
    if (name.contains('balcony') || name.contains('terrace')) return Icons.deck_outlined;
    if (name.contains('gym') || name.contains('fitness')) return Icons.fitness_center_outlined;
    if (name.contains('pool')) return Icons.pool_outlined;
    if (name.contains('parking')) return Icons.local_parking_outlined;
    if (name.contains('wifi')) return Icons.wifi_outlined;
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: items
          .map((e) => AmenityChipWidget(icon: e.icon, label: e.label))
          .toList(),
    );
  }
}
