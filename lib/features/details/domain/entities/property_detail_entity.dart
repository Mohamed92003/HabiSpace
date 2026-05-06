import '../../../home/domain/entities/agent_entity.dart';

class PropertyDetailEntity {
  final int id;
  final String title;
  final String slug;
  final String description;
  final double price;
  final String listingType;
  final String address;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final int reviewsCount;
  final List<String> images;
  final Map<String, dynamic> amenities;
  final AgentEntity agent;
  final String categoryName;
  final bool isFavorited;

  const PropertyDetailEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.listingType,
    required this.address,
    this.latitude,
    this.longitude,
    this.rating,
    required this.reviewsCount,
    required this.images,
    required this.amenities,
    required this.agent,
    required this.categoryName,
    required this.isFavorited,
  });
}
