import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../domain/entities/property_detail_entity.dart';

class DetailsLocationMap extends StatelessWidget {
  final PropertyDetailEntity property;

  const DetailsLocationMap({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.locationAddress.tr(),
          style: TextStyle(
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w700,
            color: AppColors.secondBlack,
          ),
        ),
        SizedBox(height: AppSizes.h12),
        Container(
          height: AppSizes.h160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.r16),
            color: AppColors.lightBackground,
          ),
          clipBehavior: Clip.hardEdge,
        ),
      ],
    );
  }
}
