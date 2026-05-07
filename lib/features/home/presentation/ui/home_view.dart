import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/skelton/shimmer.dart';
import '../../../../core/shared/home_skeleton.dart';
import '../../../../core/shared/error_view.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../widgets/all_properties_page.dart';
import '../widgets/filter_chip_item.dart';
import '../cubit/home_cubit.dart';
import '../widgets/horizontal_list.dart';
import '../widgets/property_card.dart';
import '../widgets/search_property_card.dart';
import '../widgets/section_header.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';

List<Widget> homeViewSlivers(
  BuildContext context,
  HomeState state,
  FavoriteCubit favoriteCubit,
) {
  if (state is HomeLoading) {
    return [
      SliverFillRemaining(
        child: AppSkeleton(
          isLoading: true,
          skeleton: const HomeSkeleton(),
          child: const SizedBox(),
        ),
      ),
    ];
  }

  if (state is HomeError) {
    return [
      SliverErrorView(
        message: state.message,
        onRetry: () => context.read<HomeCubit>().getHome(),
      ),
    ];
  }

  if (state is HomeSearchSuccess) {
    if (state.results.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Text(
              state.query.isEmpty
                  ? AppTexts.noPropertiesFound.tr()
                  : '${AppTexts.noResultsFor.tr()} "${state.query}"',
              style: TextStyle(fontSize: AppSizes.sp16, color: Colors.grey),
            ),
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w16,
          vertical: AppSizes.h12,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: EdgeInsets.only(bottom: AppSizes.h12),
              child: SearchPropertyCard(property: state.results[index]),
            ),
            childCount: state.results.length,
          ),
        ),
      ),
    ];
  }

  if (state is HomeSuccess) {
    final tabs = ['All', ...state.home.categories.map((c) => c.name)];

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                tabs.length,
                (index) => FilterChipItem(
                  text: tabs[index] ?? "",
                  isSelected: state.selectedTab == index,
                  onTap: () =>
                      context.read<HomeCubit>().filterByCategory(index),
                ),
              ),
            ),
          ),
        ),
      ),

      SliverToBoxAdapter(child: SizedBox(height: AppSizes.h16)),

      if (state.filteredBestSelling.isNotEmpty) ...[
        SectionHeader(
          title: AppTexts.bestOffers.tr(),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: favoriteCubit,
                child: AllPropertiesPage(
                  title: AppTexts.bestOffers.tr(),
                  properties: state.filteredBestSelling,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSizes.h12)),
        HorizontalList(
          items: state.filteredBestSelling,
          builder: (index) =>
              PropertyCard(property: state.filteredBestSelling[index]),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSizes.h16)),
      ],

      if (state.filteredFeatured.isNotEmpty) ...[
        SectionHeader(
          title: AppTexts.featured.tr(),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: favoriteCubit,
                child: AllPropertiesPage(
                  title: AppTexts.featured.tr(),
                  properties: state.filteredFeatured,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSizes.h12)),
        HorizontalList(
          items: state.filteredFeatured,
          builder: (index) =>
              PropertyCard(property: state.filteredFeatured[index]),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSizes.h16)),
      ],

      if (state.filteredRecommended.isNotEmpty) ...[
        SectionHeader(
          title: AppTexts.recommended.tr(),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: favoriteCubit,
                child: AllPropertiesPage(
                  title: AppTexts.recommended.tr(),
                  properties: state.filteredRecommended,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSizes.h12)),
        HorizontalList(
          items: state.filteredRecommended,
          builder: (index) =>
              PropertyCard(property: state.filteredRecommended[index]),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSizes.h16)),
      ],

      if (state.filteredBestSelling.isEmpty &&
          state.filteredFeatured.isEmpty &&
          state.filteredRecommended.isEmpty)
        SliverFillRemaining(
          child: Center(
            child: Text(
              AppTexts.noPropertiesFound.tr(),
              style: TextStyle(fontSize: AppSizes.sp16, color: Colors.grey),
            ),
          ),
        ),
      SliverToBoxAdapter(child: SizedBox(height: AppSizes.h24)),
    ];
  }

  return [const SliverToBoxAdapter(child: SizedBox())];
}
