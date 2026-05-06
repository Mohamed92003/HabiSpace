import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habispace/core/router/app_router.dart';
import 'package:habispace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import '../../../../core/utils/app_sizes.dart';

class DeleteAccountPopup extends StatelessWidget {
  const DeleteAccountPopup({super.key});

  static void show(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();


    showMenu(
      context: context,
      color: Colors.transparent,
      elevation: 0,
      position: RelativeRect.fromLTRB(50, 200, 50, 0),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          child: BlocProvider.value(
            value: profileCubit,
            child: const _DeletePopupContent(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _DeletePopupContent extends StatelessWidget {
  const _DeletePopupContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileDeleted) {
          Navigator.of(context, rootNavigator: true).pop();
          context.go(AppRoutes.login);
        } else if (state is ProfileError) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Delete Account',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Are you sure you want to permanently delete your account? This cannot be undone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final isLoading = state is ProfileLoading;
                return Column(
                  children: [
                    // Delete button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => context.read<ProfileCubit>().deleteProfile(),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.red,
                          disabledBackgroundColor: Colors.red.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Yes, Delete My Account',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Cancel button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(context, rootNavigator: true).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).colorScheme.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
