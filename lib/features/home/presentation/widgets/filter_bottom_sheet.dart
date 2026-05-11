import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/location/location_cubit.dart';
import '../../../../core/theme/app_theme.dart';
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
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, locationState) {
        final locationLoaded = locationState is LocationLoaded
            ? locationState
            : null;
        final locationLoading = locationState is LocationLoading;

        return Container(
          padding: EdgeInsets.fromLTRB(
            AppSizes.w16,
            AppSizes.h24,
            AppSizes.w16,
            AppSizes.h32,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.r24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: AppSizes.w40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.appTheme.divider,
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

              // ── Listing type ──────────────────────────────────────────────
              Text(
                AppTexts.listingType.tr(),
                style: const TextStyle(fontWeight: FontWeight.w600),
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

              // ── Radius slider ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTexts.radius.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${_radius.toInt()} km',
                    style: TextStyle(
                      color: locationLoaded != null
                          ? AppColors.blue
                          : context.appTheme.subtleText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h8),

              // Location status indicator
              _buildLocationStatus(context, locationState),

              Slider(
                value: _radius,
                min: 5,
                max: 200,
                divisions: 39,
                activeColor: locationLoaded != null
                    ? AppColors.blue
                    : context.appTheme.subtleText,
                inactiveColor: context.appTheme.divider,
                // Disabled until location is confirmed
                onChanged: locationLoaded != null
                    ? (v) => setState(() => _radius = v)
                    : null,
              ),

              SizedBox(height: AppSizes.h24),

              // ── Action buttons ────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r12),
                        ),
                      ),
                      onPressed: () {
                        context.read<HomeCubit>().clearFilter();
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppTexts.clear.tr(),
                        style: const TextStyle(color: AppColors.blue),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.w12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r12),
                        ),
                      ),
                      // Disable Apply while location is still resolving
                      onPressed: locationLoading
                          ? null
                          : () {
                              context.read<HomeCubit>().applyFilter(
                                FilterEntity(
                                  listingType: _selectedType,
                                  // Only attach radius when we have a real
                                  // center point — otherwise omit it entirely
                                  radiusKm: locationLoaded != null
                                      ? _radius
                                      : null,
                                  latitude: locationLoaded?.latitude,
                                  longitude: locationLoaded?.longitude,
                                ),
                              );
                              Navigator.pop(context);
                            },
                      child: Text(
                        AppTexts.apply.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationStatus(BuildContext context, LocationState state) {
    if (state is LocationLoading) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSizes.h8),
        child: Row(
          children: [
            SizedBox(
              width: AppSizes.sp14,
              height: AppSizes.sp14,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.blue,
              ),
            ),
            SizedBox(width: AppSizes.w8),
            Text(
              'Getting your location...',
              style: TextStyle(
                fontSize: AppSizes.sp12,
                color: context.appTheme.subtleText,
              ),
            ),
          ],
        ),
      );
    }

    if (state is LocationLoaded) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSizes.h4),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              size: AppSizes.sp14,
              color: Colors.green.shade600,
            ),
            SizedBox(width: AppSizes.w4),
            Expanded(
              child: Text(
                state.displayName,
                style: TextStyle(
                  fontSize: AppSizes.sp12,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (state is LocationError) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSizes.h4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_off,
              size: AppSizes.sp14,
              color: Colors.orange.shade700,
            ),
            SizedBox(width: AppSizes.w4),
            Expanded(
              child: Text(
                'Location unavailable — radius filter disabled',
                style: TextStyle(
                  fontSize: AppSizes.sp12,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.read<LocationCubit>().fetchLocation(),
              child: Text(
                'Retry',
                style: TextStyle(
                  fontSize: AppSizes.sp12,
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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
          color: isSelected ? AppColors.blue : context.appTheme.chipBg,
          borderRadius: BorderRadius.circular(AppSizes.r20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : context.appTheme.titleText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
