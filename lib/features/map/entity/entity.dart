import 'package:equatable/equatable.dart';

class PropertyLocation extends Equatable {
  final int id;
  final double lat;
  final double lng;
  final String title;
  final double price;
  final String? imageUrl;
  final String address;
  final String listingType;

  const PropertyLocation({
    required this.id,
    required this.lat,
    required this.lng,
    required this.title,
    required this.price,
    this.imageUrl,
    this.address = '',
    this.listingType = '',
  });

  /// Formatted price label shown on the map marker.
  String get priceLabel {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(0)}K';
    }
    return '\$${price.toStringAsFixed(0)}';
  }

  @override
  List<Object?> get props => [
    id,
    lat,
    lng,
    title,
    price,
    imageUrl,
    address,
    listingType,
  ];
}
