import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:habispace/core/shared/skelton/shimmer.dart';
import 'package:habispace/core/shared/home_skeleton.dart';
import 'package:habispace/features/home/presentation/widgets/search_property_card.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../domain/entities/home_property_entity.dart';

class AllPropertiesPage extends StatelessWidget {
  final String title;
  final List<HomePropertyEntity> properties;
  final bool isLoading;
  const AllPropertiesPage({
    super.key,
    required this.title,
    required this.properties,
    this.isLoading=false
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppSizes.sp18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: AppSkeleton(
         isLoading: isLoading,
        skeleton: const HomeSkeleton(),
        child: properties.isEmpty
            ? Center(
          child: Text(
            AppTexts.noPropertiesFound.tr(),
            style: TextStyle(
              fontSize: AppSizes.sp16,
              color: Colors.grey,
            ),
          ),
        )
            : ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w16,
            vertical: AppSizes.h16,
          ),
          itemCount: properties.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSizes.h12),
          itemBuilder: (context, index) => SearchPropertyCard(
            property: properties[index],
          ),
        ),
      ),
    );
  }
}