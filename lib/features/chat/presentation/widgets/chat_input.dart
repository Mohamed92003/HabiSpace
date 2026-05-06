import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w16,
        vertical: AppSizes.h12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: AppTexts.typeAMessage.tr(),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: AppSizes.sp14,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: AppSizes.h12),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.w8),
          GestureDetector(
            onTap: isSending ? null : onSend,
            child: Container(
              width: AppSizes.w44,
              height: AppSizes.h44,
              decoration: BoxDecoration(
                color: isSending
                    ? colorScheme.primary.withValues(alpha: 0.5)
                    : colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: isSending
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Icon(
                      CupertinoIcons.arrow_up,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
