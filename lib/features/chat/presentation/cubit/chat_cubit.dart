import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static const _prefPrefix = 'agent_name_';

  ChatCubit(
    this.getConversationUseCase,
    this.getConversationsUseCase,
    this.sendMessageUseCase,
    this.startConversationUseCase,
  ) : super(ChatInitial());

  Future<void> _saveAgentName(int conversationId, String name) async {
    if (name.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefPrefix$conversationId', name);
  }

  Future<String> _loadAgentName(int conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_prefPrefix$conversationId') ?? '';
  }

  static const _agentConvPrefix = 'agent_conv_';

  Future<int?> _getExistingConversation(int agentUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('$_agentConvPrefix$agentUserId');
    return id;
  }

  Future<void> _saveAgentConversation(
    int agentUserId,
    int conversationId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_agentConvPrefix$agentUserId', conversationId);
  }

  Future<void> loadConversations() async {
    emit(ChatLoading());
    try {
      final conversations = await getConversationsUseCase();
      final named = await Future.wait(
        conversations.map((c) async {
          final name = c.agentName.isNotEmpty
              ? c.agentName
              : await _loadAgentName(c.id);
          return ConversationEntity(
            id: c.id,
            propertyId: c.propertyId,
            buyerId: c.buyerId,
            agentId: c.agentId,
            agentName: name,
            messages: c.messages,
            createdAt: c.createdAt,
          );
        }),
      );
      emit(ConversationsLoaded(named));
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

  Future<void> startConversation(
    int agentUserId,
    int propertyId, {
    String agentName = '',
  }) async {
    emit(ChatLoading());
    try {
      final existingId = await _getExistingConversation(agentUserId);
      if (existingId != null) {
        final conversation = await getConversationUseCase(existingId);
        final resolvedName = conversation.agentName.isNotEmpty
            ? conversation.agentName
            : agentName;
        emit(ChatLoaded(
          conversation: ConversationEntity(
            id: conversation.id,
            propertyId: conversation.propertyId,
            buyerId: conversation.buyerId,
            agentId: conversation.agentId,
            agentName: resolvedName,
            messages: conversation.messages,
            createdAt: conversation.createdAt,
          ),
        ));
        return;
      }
      final conversation = await startConversationUseCase(agentUserId, propertyId);
      final resolvedName = conversation.agentName.isNotEmpty
          ? conversation.agentName
          : agentName;
      await _saveAgentName(conversation.id, resolvedName);
      await _saveAgentConversation(agentUserId, conversation.id);
      emit(ChatLoaded(
        conversation: ConversationEntity(
          id: conversation.id,
          propertyId: conversation.propertyId,
          buyerId: conversation.buyerId,
          agentId: conversation.agentId,
          agentName: resolvedName,
          messages: conversation.messages,
          createdAt: conversation.createdAt,
        ),
      ));
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
        agentName: currentState.conversation.agentName,
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
