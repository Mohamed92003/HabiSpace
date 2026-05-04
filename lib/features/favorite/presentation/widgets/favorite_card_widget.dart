
import 'package:flutter/material.dart';
import 'package:habispace/features/favorite/presentation/widgets/property_image_widget.dart';
import 'package:habispace/features/favorite/presentation/widgets/type_badge_widget.dart';

import '../../../favorite/domain/entities/favorite_property_entity.dart';
import 'amenity_chip_widget.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
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
          height: 200,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        Positioned(
          top: 12,
          left: 12,
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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(title: property.title, onFavoriteTap: onFavoriteTap),
          const SizedBox(height: 8),
          _LocationRow(address: property.address, distance: property.distance),
          const SizedBox(height: 10),
          AmenitiesWrap(property: property),
          const SizedBox(height: 12),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onFavoriteTap,
          child: const Icon(Icons.star, color: Color(0xFFFFC107), size: 26),
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
    return Row(
      children: [
        const Icon(Icons.location_on_outlined,
            size: 15, color: Color(0xFF2BBFB3)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (distance.isNotEmpty) ...[
          const SizedBox(width: 8),
          Container(width: 1, height: 12, color: Colors.black26),
          const SizedBox(width: 8),
          const Icon(Icons.near_me_outlined,
              size: 14, color: Color(0xFF2BBFB3)),
          const SizedBox(width: 4),
          Text(
            distance,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '\$$price',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const TextSpan(
                text: '/ month',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        if (rating > 0)
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
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
