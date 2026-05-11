import 'agent_entity.dart';
import 'category_entity.dart';

class HomePropertyEntity {
  final int id;
  final String title;
  final String slug;
  final String description;
  final double price;
  final String listingType;
  final String status;
  final int bedrooms;
  final int bathrooms;
  final int kitchens;
  final bool isFeatured;
  final int salesCount;
  final double latitude;
  final double longitude;
  final String address;
  final CategoryEntity category;
  final List<String> images;
  final AgentEntity agent;
  final double? rating;
  final int reviewsCount;

  HomePropertyEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.listingType,
    required this.status,
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchens,
    required this.isFeatured,
    required this.salesCount,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.category,
    required this.images,
    required this.agent,
    this.rating,
    this.reviewsCount = 0,
  });

  HomePropertyEntity copyWithRating(double rating, int reviewsCount) {
    return HomePropertyEntity(
      id: id,
      title: title,
      slug: slug,
      description: description,
      price: price,
      listingType: listingType,
      status: status,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      kitchens: kitchens,
      isFeatured: isFeatured,
      salesCount: salesCount,
      latitude: latitude,
      longitude: longitude,
      address: address,
      category: category,
      images: images,
      agent: agent,
      rating: rating,
      reviewsCount: reviewsCount,
    );
  }
}
