import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/conversation_entity.dart';
import '../../domain/usescases/get_conversation_usecase.dart';
import '../../domain/usescases/get_conversations_usecase.dart';
import '../../domain/usescases/send_message_usecase.dart';
import '../../domain/usescases/start_conversation_usecase.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetConversationUseCase getConversationUseCase;
  final GetConversationsUseCase getConversationsUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final StartConversationUseCase startConversationUseCase;

  ChatCubit(
    this.getConversationUseCase,
    this.getConversationsUseCase,
    this.sendMessageUseCase,
    this.startConversationUseCase,
  ) : super(ChatInitial());

  Future<void> loadConversations() async {
    emit(ChatLoading());
    try {
      final conversations = await getConversationsUseCase();
      emit(ConversationsLoaded(conversations));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> loadConversation(int conversationId) async {
    emit(ChatLoading());
    try {
      final conversation = await getConversationUseCase(conversationId);
      emit(ChatLoaded(conversation: conversation));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> startConversation(int agentUserId, int propertyId) async {
    emit(ChatLoading());
    try {
      final conversation = await startConversationUseCase(
        agentUserId,
        propertyId,
      );
      emit(ChatLoaded(conversation: conversation));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage(int conversationId, String body) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    emit(currentState.copyWith(isSending: true));
    try {
      final message = await sendMessageUseCase(conversationId, body);

      final updatedMessages = [...currentState.conversation.messages, message];

      final updatedConversation = ConversationEntity(
        id: currentState.conversation.id,
        propertyId: currentState.conversation.propertyId,
        buyerId: currentState.conversation.buyerId,
        agentId: currentState.conversation.agentId,
        messages: updatedMessages,
        createdAt: currentState.conversation.createdAt,
      );

      emit(ChatLoaded(conversation: updatedConversation, isSending: false));
    } catch (e) {
      emit(currentState.copyWith(isSending: false));
      emit(ChatError(e.toString()));
    }
  }
}
