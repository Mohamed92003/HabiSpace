
import '../../domain/entities/favorite_property_entity.dart';

class FavoritePropertyModel extends FavoritePropertyEntity {
  FavoritePropertyModel({
    required super.id,
    required super.title,
    required super.price,
    required super.address,
    required super.categoryId,
    required super.categoryName,
    required super.images,
    required super.bedrooms,
    required super.bathrooms,
    super.rating,
    super.type,
    super.amenities,
    super.distance,
  });

  factory FavoritePropertyModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['images'] != null) {
      imageUrls = (json['images'] as List)
          .map((img) => img['url'].toString())
          .toList();
    }

    List<String> amenities = [];
    if (json['amenities'] != null) {
      amenities = (json['amenities'] as List)
          .map((a) => a['name']?.toString() ?? a.toString())
          .toList();
    }

    if (amenities.isEmpty) {
      final beds = json['bedrooms'] ?? 0;
      final baths = json['bathrooms'] ?? 0;
      if (beds > 0) amenities.add('$beds Bedroom${beds > 1 ? 's' : ''}');
      if (baths > 0) amenities.add('$baths Bathroom${baths > 1 ? 's' : ''}');
    }

    double rating = 0.0;
    if (json['rating'] != null) {
      rating = double.tryParse(json['rating'].toString()) ?? 0.0;
    } else if (json['average_rating'] != null) {
      rating = double.tryParse(json['average_rating'].toString()) ?? 0.0;
    }

    String type = 'For a Rent';
    if (json['type'] != null) {
      type = json['type'].toString();
    } else if (json['listing_type'] != null) {
      type = json['listing_type'].toString();
    } else if (json['purpose'] != null) {
      type = json['purpose'].toString();
    }

    String distance = '';
    if (json['distance'] != null) {
      distance = json['distance'].toString();
    }

    return FavoritePropertyModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price']?.toString() ?? '0',
      address: json['address'] ?? '',
      categoryId: json['category']?['id'] ?? 0,
      categoryName: json['category']?['name'] ?? 'Other',
      images: imageUrls,
      bathrooms: json['bathrooms'] ?? 0,
      bedrooms: json['bedrooms'] ?? 0,
      rating: rating,
      type: type,
      amenities: amenities,
      distance: distance,
    );
  }

  FavoritePropertyEntity toEntity() {
    return FavoritePropertyEntity(
      id: id,
      title: title,
      price: price,
      address: address,
      categoryId: categoryId,
      categoryName: categoryName,
      images: images,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      rating: rating,
      type: type,
      amenities: amenities,
      distance: distance,
    );
  }
}