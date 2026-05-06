import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habispace/features/map/ui/map_screen.dart';
import '../../../../core/router/app_router.dart';
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
        GestureDetector(
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder:
            (context)=> MapTabView()
            ));
          },
          child: Container(
            height: AppSizes.h160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.r16),
              color: AppColors.lightBackground,
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset('assets/images/map.png', fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
