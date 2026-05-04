
import '../../domain/chat_repo/chat_repo.dart';
import '../../domain/entity/conversation_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../datasource/chat_remote_dataSource.dart';

class ChatRepoImpl implements ChatRepo {
  final ChatRemoteDataSource remoteDataSource;
  ChatRepoImpl(this.remoteDataSource);

  @override
  Future<List<ConversationEntity>> getConversations() =>
      remoteDataSource.getConversations();

  @override
  Future<ConversationEntity> getConversation(int conversationId) =>
      remoteDataSource.getConversation(conversationId);

  @override
  Future<MessageEntity> sendMessage(int conversationId, String body) =>
      remoteDataSource.sendMessage(conversationId, body);

  @override
  Future<ConversationEntity> startConversation(
      int agentUserId, int propertyId) =>
      remoteDataSource.startConversation(agentUserId, propertyId);
}