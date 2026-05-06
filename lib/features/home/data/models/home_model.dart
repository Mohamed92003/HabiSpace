import '../../domain/entities/home_entity.dart';
import 'category_model.dart';
import 'home_property_model.dart';

class HomeModel extends HomeEntity {
  HomeModel({
    required super.categories,
    required super.bestSelling,
    required super.featured,
    required super.recommended,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return HomeModel(
      categories: (data['categories'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      bestSelling: (data['best_selling'] as List? ?? [])
          .map((e) => HomePropertyModel.fromJson(e)).toList(),
      featured: (data['featured'] as List? ?? [])
          .map((e) => HomePropertyModel.fromJson(e)).toList(),
      recommended: (data['recommended'] as List? ?? [])
          .map((e) => HomePropertyModel.fromJson(e)).toList(),
    );
  }
}