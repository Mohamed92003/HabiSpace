part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ConversationsLoaded extends ChatState {
  final List<ConversationEntity> conversations;
  ConversationsLoaded(this.conversations);
}

class ChatLoaded extends ChatState {
  final ConversationEntity conversation;
  final bool isSending;

  ChatLoaded({required this.conversation, this.isSending = false});

  ChatLoaded copyWith({ConversationEntity? conversation, bool? isSending}) {
    return ChatLoaded(
      conversation: conversation ?? this.conversation,
      isSending: isSending ?? this.isSending,
    );
  }
}
