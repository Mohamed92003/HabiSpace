import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';

class UserModel extends ProfileEntity {
  UserModel({
    required super.id,
    required super.location,
    required super.email,
    required super.name,
    required super.phone,
    super.image,
    super.role,
    super.createdAt,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? 0,
    location: json["location"] ?? '',
    email: json["email"] ?? '',
    name: json["name"] ?? '',
    phone: json["phone"] ?? '',
    image: json["image"] ?? json["avatar"] ?? json["profile_image"],
    role: json["role"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location,
        "email": email,
        "name": name,
        "phone": phone,
        "image": image,
        "role": role,
        "created_at": createdAt,
      };
}