class ProfileEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String? image;
  final String? role;
  final String? createdAt;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.phone,
    this.image,
    this.role,
    this.createdAt,
  });
}
