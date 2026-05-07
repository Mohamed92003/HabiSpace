import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habispace/core/shared/custom_svg.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../cubit/home_cubit.dart';
import '../../domain/entities/home_property_entity.dart';

class SearchPropertyCard extends StatelessWidget {
  final HomePropertyEntity property;

  const SearchPropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return GestureDetector(
      onTap: () {
        final homeState = context.read<HomeCubit>().state;
        final similar = homeState is HomeSuccess
            ? homeState.filteredRecommended
                  .where((p) => p.id != property.id)
                  .take(5)
                  .toList()
            : <HomePropertyEntity>[];
        context.push(
          AppRoutes.details,
          extra: {
            'propertyId': property.id,
            'favoriteCubit': context.read<FavoriteCubit>(),
            'similarProperties': similar,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ext.cardBg,
          boxShadow: [
            BoxShadow(
              color: ext.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                property.images.isNotEmpty && property.images[0].isNotEmpty
                    ? SizedBox(
                        height: AppSizes.h140,
                        width: AppSizes.w360,
                        child: CachedNetworkImage(
                          imageUrl: property.images[0],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _PropertyImagePlaceholder(
                                width: AppSizes.w360,
                                height: AppSizes.h140,
                                showShimmer: true,
                              ),
                          errorWidget: (context, url, error) =>
                              _PropertyImagePlaceholder(
                                width: AppSizes.w360,
                                height: AppSizes.h140,
                              ),
                        ),
                      )
                    : _PropertyImagePlaceholder(
                        width: AppSizes.w360,
                        height: AppSizes.h140,
                      ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w8,
                      vertical: AppSizes.h6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ext.badgeBg,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvgImage(
                          path: 'assets/icons/sale_icon.svg',
                          height: AppSizes.h16,
                          width: AppSizes.w16,
                        ),
                        SizedBox(width: AppSizes.w4),
                        Text(
                          property.listingType == 'sale'
                              ? AppTexts.forSaleLabel.tr()
                              : AppTexts.forRentLabel.tr(),
                          style: TextStyle(
                            fontSize: AppSizes.sp12,
                            fontWeight: FontWeight.w500,
                            color: ext.titleText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w12,
                vertical: AppSizes.h10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: TextStyle(
                            fontSize: AppSizes.sp16,
                            fontWeight: FontWeight.w600,
                            color: ext.titleText,
                          ),
                        ),
                      ),
                      BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          final isFav = state is FavoriteLoaded
                              ? state.isFavorite(property.id)
                              : false;
                          return GestureDetector(
                            onTap: () {
                              final cubit = context.read<FavoriteCubit>();
                              isFav
                                  ? cubit.removeFavorite(property.id)
                                  : cubit.addFavorite(property.id);
                            },
                            child: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              size: AppSizes.h24,
                              color: isFav ? ext.starColor : ext.subtleText,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: AppSizes.h14,
                        color: AppColors.blue,
                      ),
                      SizedBox(width: AppSizes.w2),
                      Expanded(
                        child: Text(
                          property.address,
                          style: TextStyle(
                            fontSize: AppSizes.sp12,
                            color: ext.subtleText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${property.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: AppSizes.sp18,
                          fontWeight: FontWeight.w700,
                          color: ext.titleText,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: AppSizes.h16,
                            color: ext.starColor,
                          ),
                          SizedBox(width: AppSizes.w2),
                          Text(
                            '4.9',
                            style: TextStyle(
                              fontSize: AppSizes.sp12,
                              fontWeight: FontWeight.w600,
                              color: ext.bodyText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared image placeholder ──────────────────────────────────────────────────
class _PropertyImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final bool showShimmer;

  const _PropertyImagePlaceholder({
    required this.width,
    required this.height,
    this.showShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Container(
      width: width,
      height: height,
      color: ext.imagePlaceholder,
      child: showShimmer
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.blue,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  size: AppSizes.sp40,
                  color: ext.subtleText,
                ),
                SizedBox(height: AppSizes.h6),
                Text(
                  'No Image',
                  style: TextStyle(
                    fontSize: AppSizes.sp11,
                    color: ext.subtleText,
                  ),
                ),
              ],
            ),
    );
  }
}
