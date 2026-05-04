import '../chat_repo/chat_repo.dart';
import '../entity/conversation_entity.dart';

class GetConversationsUseCase {
  final ChatRepo repo;
  GetConversationsUseCase(this.repo);

  Future<List<ConversationEntity>> call() => repo.getConversations();
}
