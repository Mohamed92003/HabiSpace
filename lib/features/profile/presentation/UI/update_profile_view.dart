import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:habispace/core/services/local_image_storage.dart';
import 'package:habispace/core/theme/app_theme.dart';
import 'package:habispace/core/utils/app_color.dart';
import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';
import 'package:habispace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../../core/utils/app_validation.dart';

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
  File? _pickedImage; // newly picked, not yet saved
  String? _savedImagePath; // persisted local path from previous saves

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
    _locationCtrl = TextEditingController(text: widget.user.location);
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final path = await LocalImageStorage.getImagePath();
    if (path != null && File(path).existsSync()) {
      setState(() => _savedImagePath = path);
    }
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
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  Future<void> _pickImage() async {
    final source = await _showImageSourceSheet();
    if (source == null) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  Future<ImageSource?> _showImageSourceSheet() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSizes.h8),
            Container(
              width: AppSizes.w40,
              height: 4,
              decoration: BoxDecoration(
                color: context.appTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: AppSizes.h16),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            SizedBox(height: AppSizes.h8),
          ],
        ),
      ),
    );
  }

  Widget _buildInitial(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: AppColors.blue,
        ),
      ),
    );
  }

  /// Returns the image widget to show in the avatar.
  /// Priority: newly picked file > saved local path > initials
  Widget _buildAvatarImage(String name) {
    if (_pickedImage != null) {
      return Image.file(
        _pickedImage!,
        fit: BoxFit.cover,
        width: 96,
        height: 96,
      );
    }
    if (_savedImagePath != null) {
      return Image.file(
        File(_savedImagePath!),
        fit: BoxFit.cover,
        width: 96,
        height: 96,
        errorBuilder: (_, __, ___) => _buildInitial(name),
      );
    }
    return _buildInitial(name);
  }

  bool _validatePhone() {
    final error = AppValidators.phone(_phoneCtrl.text);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  void _save() {
    if (!_validatePhone()) return;

    // Save image locally immediately — don't wait for the API
    if (_pickedImage != null) {
      LocalImageStorage.saveImage(_pickedImage!.path).then((permanentPath) {
        if (!mounted) return;
        setState(() {
          _savedImagePath = permanentPath;
          _pickedImage = null;
        });
        // Notify cubit so profile page and bottom nav update
        context.read<ProfileCubit>().onLocalImageSaved(permanentPath);
      });
    }

    context.read<ProfileCubit>().updateProfile(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      imagePath: null, // don't send to backend
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppTexts.profileUpdatedSuccess.tr()),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final liveUser = (state is ProfileLoaded && state.profile.isNotEmpty)
            ? state.profile.first
            : (state is ProfileUpdating && state.profile.isNotEmpty)
            ? state.profile.first
            : widget.user;
        final saving = state is ProfileLoading || state is ProfileUpdating;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            leading: BackButton(color: context.appTheme.titleText),
            title: Text(
              AppTexts.personalInformation.tr(),
              style: TextStyle(
                color: context.appTheme.titleText,
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
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: saving ? null : _save,
                  child: saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.blue,
                          ),
                        )
                      : Text(
                          AppTexts.saveButton.tr(),
                          style: const TextStyle(
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
                // ── Avatar ───────────────────────────────────────────────
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue.withValues(alpha: 0.1),
                        ),
                        child: ClipOval(
                          child: _buildAvatarImage(liveUser.name),
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: EdgeInsets.all(AppSizes.h6),
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: AppSizes.sp14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_isEditing) ...[
                  SizedBox(height: AppSizes.h6),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Text(
                        'Change photo',
                        style: TextStyle(
                          fontSize: AppSizes.sp12,
                          color: AppColors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: AppSizes.h28),

                // ── Editable fields ──────────────────────────────────────
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
                  maxLength: 11,
                  digitsOnly: true,
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
                      value: liveUser.email,
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      indent: 52,
                      color: context.appTheme.divider,
                    ),
                    _ReadOnlyRow(
                      icon: Icons.calendar_today_outlined,
                      label: AppTexts.memberSince,
                      value: _formatDate(liveUser.createdAt),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
          color: context.appTheme.subtleText,
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
  final int? maxLength;
  final bool digitsOnly;

  const _InfoField({
    required this.icon,
    required this.controller,
    required this.enabled,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.digitsOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appTheme.cardBg,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: enabled
              ? AppColors.blue.withValues(alpha: 0.5)
              : context.appTheme.divider,
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
              color: enabled ? AppColors.blue : context.appTheme.subtleText,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              inputFormatters: [
                if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
                if (maxLength != null)
                  LengthLimitingTextInputFormatter(maxLength),
              ],
              style: TextStyle(
                fontSize: AppSizes.sp15,
                color: context.appTheme.titleText,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint.tr(),
                hintStyle: TextStyle(
                  color: context.appTheme.subtleText,
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
        color: context.appTheme.cardBg,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: context.appTheme.divider, width: 0.8),
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
          Icon(icon, size: AppSizes.sp20, color: context.appTheme.subtleText),
          SizedBox(width: AppSizes.w14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.tr(),
                style: TextStyle(
                  fontSize: AppSizes.sp11,
                  color: context.appTheme.subtleText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSizes.h2),
              SizedBox(
                width: AppSizes.w280,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: AppSizes.sp14,
                    color: context.appTheme.titleText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
