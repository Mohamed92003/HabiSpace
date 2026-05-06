import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import '../../../../core/shared/snakbar.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileCubit>().changePassword(
      currentPassword: _currentCtrl.text,
      password: _newCtrl.text,
      passwordConfirmation: _confirmCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfilePasswordChanged) {
          _currentCtrl.clear();
          _newCtrl.clear();
          _confirmCtrl.clear();
          CustomSnackBar().successBar(context, state.message);
        }
        if (state is ProfileError) {
          CustomSnackBar().errorBar(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: AppColors.secondBlack),
          title: Text(
            AppTexts.changePasswordTitle.tr(),
            style: TextStyle(
              color: AppColors.secondBlack,
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.h20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.h16),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                    border: Border.all(color: AppColors.blue.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.blue,
                        size: AppSizes.sp20,
                      ),
                      SizedBox(width: AppSizes.w10),
                      Expanded(
                        child: Text(
                          AppTexts.changePasswordInfo.tr(),
                          style: TextStyle(
                            fontSize: AppSizes.sp13,
                            color: AppColors.blue,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.h28),

                const _FieldLabel(label: AppTexts.currentPassword),
                _PasswordField(
                  controller: _currentCtrl,
                  hint: AppTexts.currentPasswordHint,
                  showPassword: _showCurrent,
                  onToggle: () => setState(() => _showCurrent = !_showCurrent),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppTexts.currentPasswordRequired.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.h20),

                const _FieldLabel(label: AppTexts.newPasswordLabel2),
                _PasswordField(
                  controller: _newCtrl,
                  hint: AppTexts.newPasswordHint,
                  showPassword: _showNew,
                  onToggle: () => setState(() => _showNew = !_showNew),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppTexts.newPasswordRequired.tr();
                    }
                    if (v.length < 8) {
                      return AppTexts.atLeast8CharsRequired.tr();
                    }
                    if (!v.contains(RegExp(r'[A-Z]'))) {
                      return AppTexts.addAtLeastOneUppercase.tr();
                    }
                    if (!v.contains(RegExp(r'[0-9]'))) {
                      return AppTexts.addAtLeastOneNumber.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.h8),
                _StrengthIndicator(password: _newCtrl.text),
                SizedBox(height: AppSizes.h20),

                const _FieldLabel(label: AppTexts.confirmNewPassword),
                _PasswordField(
                  controller: _confirmCtrl,
                  hint: AppTexts.confirmNewPasswordHint,
                  showPassword: _showConfirm,
                  onToggle: () => setState(() => _showConfirm = !_showConfirm),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppTexts.pleaseConfirmPassword.tr();
                    }
                    if (v != _newCtrl.text) {
                      return AppTexts.passwordsDoNotMatch.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.h36),

                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state is ProfileLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: AppSizes.h52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          disabledBackgroundColor: AppColors.blue.withOpacity(
                            0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.r14),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                AppTexts.updatePassword.tr(),
                                style: TextStyle(
                                  fontSize: AppSizes.sp16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
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

// ── Helpers ───────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.h8),
      child: Text(
        label.tr(),
        style: TextStyle(
          color: AppColors.textSecondaryColor,
          fontSize: AppSizes.sp13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool showPassword;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.showPassword,
    required this.onToggle,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      validator: validator,
      style: TextStyle(
        fontSize: AppSizes.sp15,
        color: AppColors.secondBlack,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint.tr(),
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: AppSizes.sp14,
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          size: AppSizes.sp20,
          color: Colors.grey.shade400,
        ),
        suffixIcon: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          icon: Icon(
            showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: AppSizes.sp20,
            color: Colors.grey.shade400,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.w16,
          vertical: AppSizes.h14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: AppColors.borderColor, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: AppColors.borderColor, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: AppColors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

class _StrengthIndicator extends StatelessWidget {
  final String password;
  const _StrengthIndicator({required this.password});

  int get _strength {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$&*~%^]'))) score++;
    return score;
  }

  Color get _color {
    switch (_strength) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.green;
      default:
        return Colors.grey.shade300;
    }
  }

  String get _label {
    switch (_strength) {
      case 1:
        return AppTexts.passwordStrengthWeak.tr();
      case 2:
        return AppTexts.passwordStrengthFair.tr();
      case 3:
        return AppTexts.passwordStrengthGood.tr();
      case 4:
        return AppTexts.passwordStrengthStrong.tr();
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return SizedBox.shrink();
    return Row(
      children: [
        ...List.generate(4, (i) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
              decoration: BoxDecoration(
                color: i < _strength ? _color : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(AppSizes.r4),
              ),
            ),
          );
        }),
        SizedBox(width: AppSizes.w10),
        Text(
          _label,
          style: TextStyle(
            fontSize: AppSizes.sp12,
            color: _color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
