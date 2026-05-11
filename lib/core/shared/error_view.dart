import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../error/app_exception.dart';
import '../theme/app_theme.dart';
import '../utils/app_color.dart';
import '../utils/app_texts.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final AppExceptionType? type;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.type, this.onRetry});

  IconData get _icon {
    switch (type) {
      case AppExceptionType.noInternet:
        return Icons.wifi_off_rounded;
      case AppExceptionType.timeout:
        return Icons.timer_off_rounded;
      case AppExceptionType.unauthorized:
        return Icons.lock_outline_rounded;
      case AppExceptionType.serverError:
        return Icons.cloud_off_rounded;
      case AppExceptionType.notFound:
        return Icons.search_off_rounded;
      default:
        return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: 64, color: context.appTheme.subtleText),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: context.appTheme.bodyText,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(AppTexts.tryAgain.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SliverErrorView extends StatelessWidget {
  final String message;
  final AppExceptionType? type;
  final VoidCallback? onRetry;

  const SliverErrorView({
    super.key,
    required this.message,
    this.type,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ErrorView(message: message, type: type, onRetry: onRetry),
    );
  }
}
