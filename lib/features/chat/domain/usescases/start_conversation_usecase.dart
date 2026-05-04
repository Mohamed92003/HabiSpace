import '../entity/conversation_entity.dart';
import '../chat_repo/chat_repo.dart';

class StartConversationUseCase {
  final ChatRepo repo;
  StartConversationUseCase(this.repo);

  Future<ConversationEntity> call(int agentUserId, int propertyId) =>
      repo.startConversation(agentUserId, propertyId);
}
