import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../domain/entity/conversation_entity.dart';
import '../cubit/chat_cubit.dart';

class ConversationsView extends StatefulWidget {
  const ConversationsView({super.key});

  @override
  State<ConversationsView> createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<ConversationsView> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.secondBlack,
            size: AppSizes.sp18,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            color: AppColors.secondBlack,
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            );
          }

          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: AppSizes.sp48),
                  SizedBox(height: AppSizes.h12),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondaryColor),
                  ),
                  SizedBox(height: AppSizes.h16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                    ),
                    onPressed: () =>
                        context.read<ChatCubit>().loadConversations(),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ConversationsLoaded) {
            if (state.conversations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: AppSizes.sp64,
                      color: AppColors.textLightColor.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: AppSizes.h16),
                    Text(
                      'No conversations yet',
                      style: TextStyle(
                        fontSize: AppSizes.sp16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                    SizedBox(height: AppSizes.h8),
                    Text(
                      'Start a chat from a property listing',
                      style: TextStyle(
                        fontSize: AppSizes.sp13,
                        color: AppColors.textLightColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w16,
                vertical: AppSizes.h12,
              ),
              itemCount: state.conversations.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: AppColors.borderColor),
              itemBuilder: (context, index) {
                final conv = state.conversations[index];
                return _ConversationTile(
                  conversation: conv,
                  onTap: () => context.pushNamed(
                    AppRoutes.chat,
                    extra: {
                      'conversationId': conv.id,
                      'agentName': conv.agentName.isNotEmpty
                          ? conv.agentName
                          : 'Agent',
                    },
                  ),
                );
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;

  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final time = conversation.messages.isNotEmpty
        ? _formatTime(conversation.messages.last.createdAt)
        : '';

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        vertical: AppSizes.h8,
        horizontal: AppSizes.w4,
      ),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.primaryContact,
        child: Icon(
          Icons.person_outline_rounded,
          color: AppColors.blue,
          size: AppSizes.sp24,
        ),
      ),
      title: Text(
        conversation.agentName.isNotEmpty
            ? conversation.agentName
            : 'Agent #${conversation.agentId}',
        style: TextStyle(
          fontSize: AppSizes.sp14,
          fontWeight: FontWeight.w600,
          color: AppColors.secondBlack,
        ),
      ),
      subtitle: conversation.messages.isNotEmpty
          ? Text(
              conversation.messages.last.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppSizes.sp12,
                color: AppColors.textLightColor,
              ),
            )
          : null,
      trailing: Text(
        time,
        style: TextStyle(fontSize: AppSizes.sp11, color: AppColors.textLightColor),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
