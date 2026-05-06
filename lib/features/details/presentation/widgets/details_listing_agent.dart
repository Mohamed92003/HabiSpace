import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../chat/presentation/cubit/chat_cubit.dart';
import '../../domain/entities/property_detail_entity.dart';

class DetailsListingAgent extends StatefulWidget {
  final PropertyDetailEntity property;

  const DetailsListingAgent({super.key, required this.property});

  @override
  State<DetailsListingAgent> createState() => _DetailsListingAgentState();
}

class _DetailsListingAgentState extends State<DetailsListingAgent> {
  Future<void> callNumber(String? phone) async {
    final number = phone?.trim() ?? '';

    Uri url;
    if (number.isNotEmpty) {
      url = Uri(scheme: 'tel', path: number);
    } else {
      url = Uri(scheme: 'tel', path: '');
    }

    try {
      final launched = await launchUrl(url);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppTexts.couldNotOpenDialer.tr())),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppTexts.errorMessage.tr(namedArgs: {'error': e.toString()}),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final agent = widget.property.agent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.listingAgent.tr(),
          style: TextStyle(
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w700,
            color: AppColors.secondBlack,
          ),
        ),
        SizedBox(height: AppSizes.h12),
        Row(
          children: [
            CircleAvatar(
              radius: AppSizes.w24,
              backgroundColor: AppColors.textLightColor,
              backgroundImage: agent.company.startsWith('http')
                  ? NetworkImage(agent.company)
                  : null,
              child: agent.company.startsWith('http')
                  ? null
                  : Icon(
                      Icons.person,
                      color: AppColors.light,
                      size: AppSizes.h24,
                    ),
            ),
            SizedBox(width: AppSizes.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent.user.name,
                    style: TextStyle(
                      fontSize: AppSizes.sp14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondBlack,
                    ),
                  ),
                  Text(
                    agent.title,
                    style: TextStyle(
                      fontSize: AppSizes.sp11,
                      color: AppColors.textLightColor,
                    ),
                  ),
                ],
              ),
            ),
            _ContactButton(
              onTap: () {
                callNumber(agent.phone);
              },
              icon: Icons.call_outlined,
            ),
            SizedBox(width: AppSizes.w8),
            _ContactButton(
              icon: Icons.chat_bubble_outline_rounded,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final existingId = prefs.getInt('agent_conv_${agent.user.id}');
                if (existingId != null) {
                  if (!context.mounted) return;
                  context.pushNamed(
                    AppRoutes.chat,
                    extra: {
                      'conversationId': existingId,
                      'agentName': agent.user.name,
                    },
                  );
                  return;
                }
                final chatCubit = sl<ChatCubit>();
                await chatCubit.startConversation(
                  agent.user.id,
                  widget.property.id,
                  agentName: agent.user.name,
                );
                if (!context.mounted) return;
                final state = chatCubit.state;
                if (state is ChatLoaded) {
                  await prefs.setString(
                    'agent_name_${state.conversation.id}',
                    agent.user.name,
                  );
                  await prefs.setInt(
                    'agent_conv_${agent.user.id}',
                    state.conversation.id,
                  );
                  if (!context.mounted) return;
                  context.pushNamed(
                    AppRoutes.chat,
                    extra: {
                      'conversationId': state.conversation.id,
                      'agentName': agent.user.name,
                    },
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.w38,
        height: AppSizes.h38,
        decoration: const BoxDecoration(
          color: AppColors.primaryContact,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: AppSizes.h18, color: AppColors.blue),
      ),
    );
  }
}
