import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../favorite/domain/entities/favorite_property_entity.dart';
import '../cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../cubit/FavoriteCubit/favorite_cubit_state.dart';

class FavoriteFilterSheet extends StatefulWidget {
  const FavoriteFilterSheet({super.key});

  @override
  State<FavoriteFilterSheet> createState() => _FavoriteFilterSheetState();
}

class _FavoriteFilterSheetState extends State<FavoriteFilterSheet> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final state = context.read<FavoriteCubit>().state;
    final List<FavoritePropertyEntity> allFavorites =
        state is FavoriteLoaded ? state.favorites : [];

    final categories = allFavorites
        .map((p) => p.categoryName)
        .toSet()
        .toList()
      ..sort();

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.w16,
        AppSizes.h24,
        AppSizes.w16,
        AppSizes.h32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: Container(
              width: AppSizes.w40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(AppSizes.r2),
              ),
            ),
          ),
          SizedBox(height: AppSizes.h16),

          Text(
            AppTexts.filterFavorites.tr(),
            style: TextStyle(
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.h20),

          Text(
            AppTexts.category.tr(),
            style: TextStyle(
              fontSize: AppSizes.sp14,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryColor,
            ),
          ),
          SizedBox(height: AppSizes.h12),

          Wrap(
            spacing: AppSizes.w8,
            runSpacing: AppSizes.h8,
            children: [
              _CategoryChip(
                label: AppTexts.filterAll.tr(),
                isSelected: _selectedCategory == null,
                onTap: () => setState(() => _selectedCategory = null),
              ),
              ...categories.map(
                (cat) => _CategoryChip(
                  label: cat,
                  isSelected: _selectedCategory == cat,
                  onTap: () => setState(() => _selectedCategory = cat),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSizes.h28),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                  ),
                  onPressed: () {

                    context.read<FavoriteCubit>().search('');
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppTexts.clear.tr(),
                    style: TextStyle(color: AppColors.blue),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                  ),
                  onPressed: () {

                    context
                        .read<FavoriteCubit>()
                        .search(_selectedCategory ?? '');
                    Navigator.pop(context);
                  },
                  child: Text(AppTexts.apply.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w16,
          vertical: AppSizes.h8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : AppColors.bluelight,
          borderRadius: BorderRadius.circular(AppSizes.r20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.blue,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: AppSizes.sp12,
          ),
        ),
      ),
    );
  }
}
