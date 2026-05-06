import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';
import 'package:habispace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';

class UpdateProfileView extends StatefulWidget {
  final ProfileEntity user;
  const UpdateProfileView({super.key, required this.user});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _locationCtrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
    _locationCtrl = TextEditingController(text: widget.user.location);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  String _formatDate(String? iso) {
    if (iso == null) return '—';
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return iso;
    }
  }

  void _save() {
    context.read<ProfileCubit>().updateProfile(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppTexts.profileUpdatedSuccess.tr()),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: AppColors.secondBlack),
          title: Text(
            AppTexts.personalInformation.tr(),
            style: TextStyle(
              color: AppColors.secondBlack,
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            if (!_isEditing)
              TextButton(
                onPressed: () => setState(() => _isEditing = true),
                child: Text(
                  AppTexts.edit.tr(),
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              TextButton(
                onPressed: _save,
                child: Text(
                  AppTexts.saveButton.tr(),
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.h20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar row ─────────────────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.blue.withOpacity(0.1),
                      backgroundImage:
                          widget.user.image != null &&
                              widget.user.image!.isNotEmpty
                          ? NetworkImage(widget.user.image!)
                          : null,
                      child:
                          widget.user.image == null ||
                              widget.user.image!.isEmpty
                          ? Text(
                              widget.user.name.isNotEmpty
                                  ? widget.user.name[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            )
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(AppSizes.h6),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: AppSizes.sp14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.h8),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w12,
                    vertical: AppSizes.h4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.r20),
                  ),
                  child: Text(
                    widget.user.role?.toUpperCase() ?? 'USER',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: AppSizes.sp11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h28),

              // ── Editable fields ────────────────────────────────────────
              _SectionLabel(label: AppTexts.fullNameLabel),
              _InfoField(
                icon: Icons.person_outline_rounded,
                controller: _nameCtrl,
                enabled: _isEditing,
                hint: AppTexts.fullNameHint,
              ),
              SizedBox(height: AppSizes.h16),
              _SectionLabel(label: AppTexts.phoneNumberLabel),
              _InfoField(
                icon: Icons.phone_outlined,
                controller: _phoneCtrl,
                enabled: _isEditing,
                hint: AppTexts.phoneNumberHint,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: AppSizes.h16),
              _SectionLabel(label: AppTexts.locationLabel2),
              _InfoField(
                icon: Icons.location_on_outlined,
                controller: _locationCtrl,
                enabled: _isEditing,
                hint: AppTexts.yourCityHint,
              ),
              SizedBox(height: AppSizes.h24),

              _SectionLabel(label: AppTexts.accountDetails),
              _ReadOnlyCard(
                children: [
                  _ReadOnlyRow(
                    icon: Icons.email_outlined,
                    label: AppTexts.emailReadOnly,
                    value: widget.user.email,
                  ),
                  Divider(height: 1, thickness: 0.8, indent: 52),
                  _ReadOnlyRow(
                    icon: Icons.calendar_today_outlined,
                    label: AppTexts.memberSince,
                    value: _formatDate(widget.user.createdAt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

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

class _InfoField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final bool enabled;
  final String hint;
  final TextInputType keyboardType;

  const _InfoField({
    required this.icon,
    required this.controller,
    required this.enabled,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: enabled
              ? AppColors.blue.withOpacity(0.5)
              : AppColors.borderColor,
          width: enabled ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w14),
            child: Icon(
              icon,
              size: AppSizes.sp20,
              color: enabled ? AppColors.blue : Colors.grey.shade400,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
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
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: AppSizes.h14),
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyCard extends StatelessWidget {
  final List<Widget> children;
  const _ReadOnlyCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.borderColor, width: 0.8),
      ),
      child: Column(children: children),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ReadOnlyRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w16,
        vertical: AppSizes.h14,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.sp20, color: Colors.grey.shade400),
          SizedBox(width: AppSizes.w14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.tr(),
                style: TextStyle(
                  fontSize: AppSizes.sp11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSizes.h2),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppSizes.sp15,
                  color: AppColors.secondBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
