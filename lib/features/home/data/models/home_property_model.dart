import '../../domain/entities/home_property_entity.dart';
import 'agent_model.dart';
import 'category_model.dart';

class HomePropertyModel extends HomePropertyEntity {
  HomePropertyModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
    required super.price,
    required super.listingType,
    required super.status,
    required super.bedrooms,
    required super.bathrooms,
    required super.kitchens,
    required super.isFeatured,
    required super.salesCount,
    required super.latitude,
    required super.longitude,
    required super.address,
    required super.category,
    required super.images,
    required super.agent,
  });

  factory HomePropertyModel.fromJson(Map<String, dynamic> json) =>
      HomePropertyModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        description: json['description'] as String? ?? '',
        price: double.parse((json['price'] ?? 0).toString()),
        listingType: json['listing_type'] as String? ?? '',
        status: json['status'] as String? ?? '',
        bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
        bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
        kitchens: (json['kitchens'] as num?)?.toInt() ?? 0,
        isFeatured: json['is_featured'] as bool? ?? false,
        salesCount: (json['sales_count'] as num?)?.toInt() ?? 0,
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        address: json['address'] as String? ?? '',
        category: CategoryModel.fromJson(
          (json['category'] as Map<String, dynamic>?) ?? {},
        ),
        agent: AgentModel.fromJson(
          (json['agent'] as Map<String, dynamic>?) ?? {},
        ),
        images: (json['images'] as List? ?? [])
            .map((e) => e['url']?.toString() ?? '')
            .where((url) => url.isNotEmpty)
            .toList(),
      );
}
