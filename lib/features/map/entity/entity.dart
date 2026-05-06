// features/properties/domain/entities/property_location.dart

import 'package:equatable/equatable.dart';

class PropertyLocation extends Equatable {
  final double lat;
  final double lng;
  final String title;
  final String price;
  final int id;

  const PropertyLocation({
    required this.lat,
    required this.lng,
    required this.title,
    required this.price,
    required this.id,
  });

  @override
  List<Object> get props => [lat, lng, title, price, id];
}
