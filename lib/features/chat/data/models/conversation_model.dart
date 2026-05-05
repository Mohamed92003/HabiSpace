import '../../domain/entity/conversation_entity.dart';
import 'message_model.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required super.id,
    required super.propertyId,
    required super.buyerId,
    required super.agentId,
    super.agentName = '',
    required super.messages,
    required super.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final agent = json['agent'] as Map<String, dynamic>?;
    final agentUser = agent?['user'] as Map<String, dynamic>?;
    final agentName =
        agentUser?['name'] as String? ??
        agent?['name'] as String? ??
        json['agent_name'] as String? ??
        '';

    return ConversationModel(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      buyerId: json['buyer_id'] ?? json['user_id'] ?? 0,
      agentId: json['agent_id'] ?? 0,
      agentName: agentName,
      messages: (json['messages'] as List? ?? [])
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
