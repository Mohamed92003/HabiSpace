class CategoryEntity {
  final int id;
  final String? name;
  final String? slug;
  final String? description;
  final int? sortOrder;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.sortOrder,
  });
}