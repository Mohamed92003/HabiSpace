import '../../domain/entities/agent_entity.dart';
import 'agent_user_model.dart';

class AgentModel extends AgentEntity {
  AgentModel({
    required super.id,
    required super.title,
    required super.bio,
    super.licenseNumber,
    required super.company,
    required super.user,
    required super.phone,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) => AgentModel(
    id: json['id'],
    title: json['title'],
    bio: json['bio'],
    licenseNumber: json['license_number'],
    company: json['company'],
    user: AgentUserModel.fromJson(json['user']),
    phone: json['phone'],
  );
}