import '../../domain/entities/agent_user_entity.dart';

class AgentUserModel extends AgentUserEntity {
  AgentUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.location,
    super.phone,
  });

  factory AgentUserModel.fromJson(Map<String, dynamic> json) => AgentUserModel(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    role: json['role'] as String? ?? '',
    location: json['location'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
  );
}