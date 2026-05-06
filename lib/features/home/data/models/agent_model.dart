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
    id: (json['id'] as num?)?.toInt() ?? 0,
    licenseNumber: json['license_number'] as String?,
    user: AgentUserModel.fromJson(
      (json['user'] as Map<String, dynamic>?) ?? {},
    ),
    phone: json['phone'] as String?,
    title: json['title'] as String? ?? '',
    bio: json['bio'] as String? ?? '',
    company: json['company'] as String? ?? '',
  );
}
