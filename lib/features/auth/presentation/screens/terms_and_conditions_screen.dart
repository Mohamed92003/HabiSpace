import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightMedium,
      appBar: AppBar(
        backgroundColor: AppColors.lightMedium,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.secondBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppTexts.termsAndConditionsTitle.tr(),
          style: GoogleFonts.poppins(
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w600,
            color: AppColors.secondBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w24,
          vertical: AppSizes.h16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLastUpdated(context),
            SizedBox(height: AppSizes.h16),
            _buildIntro(context),
            SizedBox(height: AppSizes.h20),
            _buildSection(
              context,
              title: AppTexts.terms1Title.tr(),
              content: AppTexts.terms1Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms2Title.tr(),
              content: AppTexts.terms2Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms3Title.tr(),
              content: AppTexts.terms3Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms4Title.tr(),
              content: AppTexts.terms4Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms5Title.tr(),
              content: AppTexts.terms5Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms6Title.tr(),
              content: AppTexts.terms6Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms7Title.tr(),
              content: AppTexts.terms7Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms8Title.tr(),
              content: AppTexts.terms8Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms9Title.tr(),
              content: AppTexts.terms9Content.tr(),
            ),
            _buildSection(
              context,
              title: AppTexts.terms10Title.tr(),
              content: AppTexts.terms10Content.tr(),
            ),
            SizedBox(height: AppSizes.h32),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.h12),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.r8),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.blue, size: AppSizes.r16),
          SizedBox(width: AppSizes.w8),
          Text(
            AppTexts.lastUpdated.tr(),
            style: GoogleFonts.poppins(
              fontSize: AppSizes.sp12,
              color: AppColors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Text(
      AppTexts.termsIntro.tr(),
      style: GoogleFonts.poppins(
        fontSize: AppSizes.sp12,
        color: AppColors.secondBlack.withValues(alpha: 0.75),
        height: 1.7,
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.h20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: AppSizes.sp14,
              fontWeight: FontWeight.w600,
              color: AppColors.secondBlack,
            ),
          ),
          SizedBox(height: AppSizes.h8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: AppSizes.sp12,
              fontWeight: FontWeight.w400,
              color: AppColors.secondBlack.withValues(alpha: 0.75),
              height: 1.7,
            ),
          ),
          SizedBox(height: AppSizes.h12),
          Divider(color: AppColors.borderColor, thickness: 1),
        ],
      ),
    );
  }
}
