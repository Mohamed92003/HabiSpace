import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../domain/entities/filter_entity.dart';
import '../cubit/home_cubit.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterEntity initialFilter;
  const FilterBottomSheet({super.key, required this.initialFilter});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedType;
  double _radius = 50;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialFilter.listingType;
    _radius = widget.initialFilter.radiusKm ?? 50;
  }

  @override
  Widget build(BuildContext context) {
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
            AppTexts.filterTitle.tr(),
            style: TextStyle(
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.h24),

          Text(
            AppTexts.listingType.tr(),
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppSizes.h12),
          Row(
            children: [
              _TypeChip(
                label: AppTexts.filterAll.tr(),
                value: null,
                selected: _selectedType,
                onTap: (v) => setState(() => _selectedType = v),
              ),
              SizedBox(width: AppSizes.w8),
              _TypeChip(
                label: AppTexts.filterSale.tr(),
                value: 'sale',
                selected: _selectedType,
                onTap: (v) => setState(() => _selectedType = v),
              ),
              SizedBox(width: AppSizes.w8),
              _TypeChip(
                label: AppTexts.filterRent.tr(),
                value: 'rent',
                selected: _selectedType,
                onTap: (v) => setState(() => _selectedType = v),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTexts.radius.tr(),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${_radius.toInt()} km',
                style: TextStyle(color: AppColors.blue),
              ),
            ],
          ),
          Slider(
            value: _radius,
            min: 5,
            max: 200,
            divisions: 39,
            activeColor: AppColors.blue,
            onChanged: (v) => setState(() => _radius = v),
          ),
          SizedBox(height: AppSizes.h24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.blue),
                  ),
                  onPressed: () {
                    context.read<HomeCubit>().clearFilter();
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
                  ),
                  onPressed: () {
                    context.read<HomeCubit>().applyFilter(
                      FilterEntity(
                        listingType: _selectedType,
                        radiusKm: _radius,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppTexts.apply.tr(),
                    style: TextStyle(color: Colors.white),
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

class _TypeChip extends StatelessWidget {
  final String label;
  final String? value;
  final String? selected;
  final ValueChanged<String?> onTap;

  const _TypeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w20,
          vertical: AppSizes.h8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(AppSizes.r20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
