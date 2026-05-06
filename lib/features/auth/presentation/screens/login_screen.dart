import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habispace/features/auth/presentation/logic/auth_bloc.dart';
import 'package:habispace/features/auth/presentation/logic/auth_state.dart';
import 'package:habispace/features/auth/presentation/screens/terms_and_conditions_screen.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/shared/custom_svg.dart';
import '../../../../core/shared/custom_textformfield.dart';
import '../../../../core/shared/snakbar.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../../core/utils/app_validation.dart';
import 'in_our_privacy_policy_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _getErrorMessage(String apiMessage) {
    final msg = apiMessage.toLowerCase();
    if (msg.contains('invalid credentials') || msg.contains('unauthorized')) {
      return AppTexts.incorrectEmailOrPassword.tr();
    }
    if (msg.contains('email')) return AppTexts.pleaseCheckEmail.tr();
    if (msg.contains('password')) return AppTexts.incorrectPassword.tr();
    if (msg.contains('not found') || msg.contains('no account')) {
      return AppTexts.noAccountFound.tr();
    }
    if (msg.contains('server') || msg.contains('500')) {
      return AppTexts.serverError.tr();
    }
    return apiMessage;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppSizes.h80),
                    CustomSvgImage(
                      path: "assets/images/logo2.svg",
                      height: AppSizes.h50,
                      width: AppSizes.w170,
                    ),
                    SizedBox(height: AppSizes.h24),
                    Text(
                      AppTexts.signInAccount.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.h20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondBlack,
                      ),
                    ),
                    SizedBox(height: AppSizes.h24),
                    CustomTextformfeild(
                      keyboardType: TextInputType.emailAddress,
                      hintText: AppTexts.emailFieldLabel.tr(),
                      controller: _emailController,
                      validator: AppValidators.email,
                      formFieldKey: const Key("email"),
                      labelText: AppTexts.emailFieldLabel.tr(),
                      labelcolor: AppColors.secondBlack,
                      borderRadius: AppSizes.r10,
                    ),
                    SizedBox(height: AppSizes.h16),
                    CustomTextformfeild(
                      keyboardType: TextInputType.visiblePassword,
                      hintText: AppTexts.passwordFieldLabel.tr(),
                      controller: _passwordController,
                      validator: AppValidators.password,
                      formFieldKey: const Key("password"),
                      labelText: AppTexts.passwordFieldLabel.tr(),
                      isPassword: true,
                      labelcolor: AppColors.secondBlack,
                      borderRadius: AppSizes.r10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(AppRoutes.forgotPassword),
                        child: Text(
                          AppTexts.forgotPassword.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.h12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.h24),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          CustomSnackBar().successBar(
                            context,
                            AppTexts.welcomeBack.tr(
                              namedArgs: {'name': state.user.username},
                            ),
                          );
                          context.go(AppRoutes.home);
                        } else if (state is AuthError) {
                          CustomSnackBar().errorBar(
                            context,
                            _getErrorMessage(state.message),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      SignInWithEmailEvent(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(double.infinity, AppSizes.h40),
                            backgroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r8),
                            ),
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  AppTexts.loginButton.tr(),
                                  style: GoogleFonts.poppins(
                                    fontSize: AppSizes.sp12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.light,
                                  ),
                                ),
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.h24),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 2,
                            width: AppSizes.w120,
                            color: AppColors.borderColor,
                          ),
                          Text(
                            AppTexts.orLoginWith.tr(),
                            style: GoogleFonts.inter(
                              fontSize: AppSizes.sp16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondBlack,
                            ),
                          ),
                          Container(
                            height: 2,
                            width: AppSizes.w120,
                            color: AppColors.borderColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.h18),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          CustomSnackBar().successBar(
                            context,
                            AppTexts.welcomeBack.tr(
                              namedArgs: {'name': state.user.username},
                            ),
                          );
                          context.go(AppRoutes.home);
                        } else if (state is AuthError) {
                          CustomSnackBar().errorBar(
                            context,
                            _getErrorMessage(state.message),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton.icon(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  context.read<AuthBloc>().add(
                                    SignInWithGoogleEvent(),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            minimumSize: Size(double.infinity, AppSizes.h50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r16),
                            ),
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            color: AppColors.blue,
                            size: AppSizes.r20,
                          ),
                          label: Text(
                            AppTexts.continueWithGoogle.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.sp16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.h24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppTexts.dontHaveAccount.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.sp12,
                            color: AppColors.secondBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.signup),
                          child: Text(
                            AppTexts.signUp.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.sp12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppTexts.bySigningInAgree.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.sp12,
                            color: AppColors.secondBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsAndConditionsScreen(),
                            ),
                          ),
                          child: SizedBox(
                            width: AppSizes.w120,
                            child: Text(
                              AppTexts.termsAndConditions.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.sp12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppTexts.learnHowWeUseData.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.sp12,
                            color: AppColors.secondBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen(),
                            ),
                          ),
                          child: SizedBox(
                            width: AppSizes.w120,
                            child: Text(
                              AppTexts.inOurPrivacyPolicy.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: AppSizes.sp12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
