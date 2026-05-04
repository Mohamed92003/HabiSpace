import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../domain/entities/property_detail_entity.dart';

class DetailsDescription extends StatelessWidget {
  final PropertyDetailEntity property;

  const DetailsDescription({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.description.tr(),
          style: TextStyle(
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w700,
            color: AppColors.secondBlack,
          ),
        ),
        SizedBox(height: AppSizes.h8),
        ReadMoreText(
          property.description,
          trimLines: 4,
          trimMode: TrimMode.Line,
          trimCollapsedText: '  ${AppTexts.seeMore.tr()}',
          trimExpandedText: '  ${AppTexts.seeLess.tr()}',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: AppSizes.sp13,
            color: AppColors.textSecondaryColor,
            height: 1.6,
          ),
          moreStyle: TextStyle(
            fontSize: AppSizes.sp13,
            color: AppColors.blue,
            fontWeight: FontWeight.w500,
          ),
          lessStyle: TextStyle(
            fontSize: AppSizes.sp13,
            color: AppColors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
