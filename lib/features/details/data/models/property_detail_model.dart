import '../../../home/data/models/agent_model.dart';
import '../../../home/domain/entities/agent_entity.dart';
import '../../domain/entities/property_detail_entity.dart';

class PropertyDetailModel extends PropertyDetailEntity {
  const PropertyDetailModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
    required super.price,
    required super.listingType,
    required super.address,
    super.latitude,
    super.longitude,
    super.rating,
    required super.reviewsCount,
    required super.images,
    required super.amenities,
    required super.agent,
    required super.categoryName,
    required super.isFavorited,
  });

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? json) as Map<String, dynamic>;

    final agentJson = data['agent'] as Map<String, dynamic>? ?? {};
    final AgentEntity agent = AgentModel.fromJson(agentJson);

    final List<String> images = (data['images'] as List<dynamic>? ?? [])
        .map((e) {
          if (e is Map) return e['url']?.toString() ?? '';
          return e.toString();
        })
        .where((url) => url.isNotEmpty)
        .toList();

    final Map<String, dynamic> amenities =
        (data['amenities'] as Map<String, dynamic>?) ??
            {
              'bedrooms': data['bedrooms'],
              'bathrooms': data['bathrooms'],
              'area': data['area'],
              'garages': data['garages'],
              'kitchens': data['kitchens'],
            };

    return PropertyDetailModel(
        id: data['id'] as int? ?? 0 ,
      title: data['title'] as String? ?? '',
      slug: data['slug'] as String? ?? '',
      description: data['description'] as String? ?? '',

      price: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
      listingType: data['listing_type'] as String? ?? 'sale',
      address: data['address'] as String? ?? '',
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),

      rating: (data['rate'] as num?)?.toDouble() ??
          (data['rating'] as num?)?.toDouble(),
      reviewsCount: data['reviews_count'] as int? ?? 0,
      images: images,
      amenities: amenities,
      agent: agent,
      categoryName: data['category']?['name'] as String? ?? '',
      isFavorited: data['is_favorited'] as bool? ?? false,
    );
  }
}