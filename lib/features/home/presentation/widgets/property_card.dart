import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../domain/entities/home_property_entity.dart';

class PropertyCard extends StatelessWidget {
  final HomePropertyEntity property;
  const PropertyCard({super.key, required this.property});

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
        width: AppSizes.w220,
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
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child:
                      property.images.isNotEmpty &&
                          property.images[0].isNotEmpty
                      ? SizedBox(
                          height: AppSizes.h140,
                          width: AppSizes.w220,

                          // child: Image.network(
                          //   property.images[0],
                          //   fit: BoxFit.cover,
                          //   loadingBuilder: (context, child, progress) {
                          //     if (progress == null) return child;
                          //     return _PropertyImagePlaceholder(
                          //       width: AppSizes.w220,
                          //       height: AppSizes.h140,
                          //       showShimmer: true,
                          //     );
                          //   },
                          //   errorBuilder: (context, error, stackTrace) =>
                          //       _PropertyImagePlaceholder(
                          //         width: AppSizes.w220,
                          //         height: AppSizes.h140,
                          //       ),
                          // ),
                          child: CachedNetworkImage(
                            imageUrl: property.images[0],
                            fit: BoxFit.cover,
                            width: double.infinity, // أو العرض اللي تحبه
                            height: AppSizes.h140, // نفس الارتفاع اللي بتستخدمه
                            // الـ Placeholder هو الـ Shimmer بتاعك اللي بيظهر والصورة بتتحمل
                            placeholder: (context, url) =>
                                _PropertyImagePlaceholder(
                                  width: AppSizes.w220,
                                  height: AppSizes.h140,
                                  showShimmer: true,
                                ),

                            // الـ errorWidget بيظهر لو اللينك بايظ أو مفيش نت
                            errorWidget: (context, url, error) =>
                                _PropertyImagePlaceholder(
                                  width: AppSizes.w220,
                                  height: AppSizes.h140,
                                  showShimmer:
                                      false, // هنا مش محتاج شيمر لأنه خلاص فشل
                                ),
                          ),
                        )
                      : _PropertyImagePlaceholder(
                          width: AppSizes.w220,
                          height: AppSizes.h140,
                        ),
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
                        SvgPicture.asset(
                          'assets/icons/sale_icon.svg',
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
                          overflow: TextOverflow.ellipsis,
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
