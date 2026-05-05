import 'message_entity.dart';

class ConversationEntity {
  final int id;
  final int propertyId;
  final int buyerId;
  final int agentId;
  final String agentName;
  final List<MessageEntity> messages;
  final DateTime createdAt;

  ConversationEntity({
    required this.id,
    required this.propertyId,
    required this.buyerId,
    required this.agentId,
    this.agentName = '',
    required this.messages,
    required this.createdAt,
  });
}
