import 'agent_user_entity.dart';

class AgentEntity {
  final int id;
  final String title;
  final String bio;
  final String? licenseNumber;
  final String company;
  final AgentUserEntity user;
  final String? phone;

  AgentEntity({
    required this.id,
    required this.title,
    required this.bio,
    this.licenseNumber,
    required this.company,
    required this.user,
    required this.phone,
  });
}