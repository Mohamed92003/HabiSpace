import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habispace/features/mainlayout/presentation/widgets/header_icon_button.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../home/presentation/widgets/filter_bottom_sheet.dart';

class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final String hint;
  final bool showFilter;

  HomeHeaderDelegate({
    required this.searchController,
    required this.onSearch,
    this.hint = 'Search your home',
    this.showFilter = true,
  });

  @override
  double get minExtent => 110;

  @override
  double get maxExtent => 110;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return RepaintBoundary(
      child: Container(
        height: AppSizes.h140,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: AppSizes.h52,
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
                  margin: EdgeInsets.symmetric(horizontal: AppSizes.w10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSizes.r30),
                  ),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearch,
                      cursorHeight: 15,
                      cursorWidth: 2,
                      cursorColor: AppColors.blue,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: AppColors.textSecondaryColor,
                          fontSize: AppSizes.sp14,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: const Icon(
                          CupertinoIcons.search,
                          color: AppColors.textSecondaryColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (showFilter)
                HeaderIconButton(
                  path: 'assets/icons/mi_filter.svg',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => BlocProvider.value(
                        value: context.read<HomeCubit>(),
                        child: FilterBottomSheet(
                          initialFilter: context.read<HomeCubit>().activeFilter,
                        ),
                      ),
                    );
                  },
                  width: AppSizes.w16,
                  height: AppSizes.h16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeHeaderDelegate oldDelegate) =>
      oldDelegate.searchController != searchController ||
      oldDelegate.hint != hint ||
      oldDelegate.showFilter != showFilter;
}
