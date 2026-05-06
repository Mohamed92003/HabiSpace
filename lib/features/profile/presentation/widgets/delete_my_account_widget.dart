import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habispace/core/router/app_router.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import '../../../../core/utils/app_sizes.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileDeleted) {
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
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppSizes.w24),
            padding: EdgeInsets.all(AppSizes.h24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.r20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppSizes.w72,
                  height: AppSizes.h72,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: AppSizes.sp36,
                  ),
                ),
                SizedBox(height: AppSizes.h20),

                Text(
                  'Delete Account',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.sp20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: AppSizes.h8),

                Text(
                  'Are you sure you want to permanently\ndelete your account? This action\ncannot be undone.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.sp13,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSizes.h28),

                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state is ProfileLoading;

                    return Column(
                      children: [
                        // Delete button
                        SizedBox(
                          width: double.infinity,
                          height: AppSizes.h50,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => context
                                      .read<ProfileCubit>()
                                      .deleteProfile(),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.red,
                              disabledBackgroundColor: Colors.red.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.r14,
                                ),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Yes, Delete My Account',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.sp14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: AppSizes.h12),

                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          height: AppSizes.h50,
                          child: OutlinedButton(
                            onPressed: isLoading ? null : () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.r14,
                                ),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.sp14,
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
        ),
      ),
    );
  }
}
