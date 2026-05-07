import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_color.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../../../home/domain/entities/home_property_entity.dart';
import '../../../../core/utils/app_sizes.dart';

class DetailsYouMustAlsoLike extends StatelessWidget {
  final List<HomePropertyEntity> properties;

  const DetailsYouMustAlsoLike({super.key, required this.properties});

  String _formatPrice(double price) {
    final parts = price.toInt().toString().split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You Must Also Like',
          style: TextStyle(
            fontSize: AppSizes.sp16,
            fontWeight: FontWeight.w700,
            color: AppColors.secondBlack,
          ),
        ),
        SizedBox(height: AppSizes.h12),
        ...properties.map(
          (p) => Padding(
            padding: EdgeInsets.only(bottom: AppSizes.h16),
            child: GestureDetector(
              onTap: () {
                final favCubit = context.read<FavoriteCubit>();
                context.push(
                  AppRoutes.details,
                  extra: {
                    'propertyId': p.id,
                    'favoriteCubit': favCubit,
                    'similarProperties': properties
                        .where((s) => s.id != p.id)
                        .toList(),
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: AppSizes.h180,
                          width: double.infinity,
                          child: p.images.isNotEmpty
                              ? CachedNetworkImage(
                               imageUrl:    p.images[0],
                                  fit: BoxFit.cover,
                                  // errorBuilder: (_, __, ___) =>
                                  //     Container(color: AppColors.borderColor),
                                )
                              : Container(color: AppColors.borderColor),
                        ),
                        Positioned(
                          top: AppSizes.h10,
                          left: AppSizes.w10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.w10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppSizes.r20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sell_outlined,
                                  size: AppSizes.sp12,
                                  color: AppColors.blue,
                                ),
                                SizedBox(width: AppSizes.w4),
                                Text(
                                  p.listingType == 'sale'
                                      ? 'For Sale'
                                      : 'For a Rent',
                                  style: TextStyle(
                                    fontSize: AppSizes.sp11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.title,
                                  style: TextStyle(
                                    fontSize: AppSizes.sp15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondBlack,
                                  ),
                                ),
                              ),
                              BlocBuilder<FavoriteCubit, FavoriteState>(
                                builder: (context, state) {
                                  final isFav = state is FavoriteLoaded
                                      ? state.isFavorite(p.id)
                                      : false;
                                  return GestureDetector(
                                    onTap: () {
                                      final cubit = context
                                          .read<FavoriteCubit>();
                                      isFav
                                          ? cubit.removeFavorite(p.id)
                                          : cubit.addFavorite(p.id);
                                    },
                                    child: Icon(
                                      isFav
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      size: AppSizes.sp22,
                                      color: isFav
                                          ? Colors.amber
                                          : AppColors.secondaryColor,
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
                                size: AppSizes.sp13,
                                color: AppColors.blue,
                              ),
                              SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  p.address,
                                  style: TextStyle(
                                    fontSize: AppSizes.sp12,
                                    color: AppColors.textSecondaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.w6,
                                ),
                                child: Text(
                                  '|',
                                  style: TextStyle(
                                    color: AppColors.borderColor,
                                    fontSize: AppSizes.sp12,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.near_me_outlined,
                                size: AppSizes.sp13,
                                color: AppColors.blue,
                              ),
                              SizedBox(width: 3),
                              Text(
                                '150 miles',
                                style: TextStyle(
                                  fontSize: AppSizes.sp12,
                                  color: AppColors.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.h8),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              if (p.bedrooms > 0)
                                _AmenityChip(
                                  Icons.bed_outlined,
                                  '${p.bedrooms} Bedrooms',
                                ),
                              if (p.bathrooms > 0)
                                _AmenityChip(
                                  Icons.bathtub_outlined,
                                  '${p.bathrooms} Bathrooms',
                                ),
                              if (p.kitchens > 0)
                                _AmenityChip(Icons.kitchen_outlined, 'Kitchen'),
                            ],
                          ),
                          SizedBox(height: AppSizes.h10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\$${_formatPrice(p.price)}',
                                      style: TextStyle(
                                        fontSize: AppSizes.sp16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.secondBlack,
                                      ),
                                    ),
                                    if (p.listingType != 'sale')
                                      TextSpan(
                                        text: '/month',
                                        style: TextStyle(
                                          fontSize: AppSizes.sp12,
                                          color: AppColors.textSecondaryColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: AppSizes.sp16,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '4.8',
                                    style: TextStyle(
                                      fontSize: AppSizes.sp13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondBlack,
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
            ),
          ),
        ),
      ],
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AmenityChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w8,
        vertical: AppSizes.h4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.sp12, color: AppColors.textLightColor),
          SizedBox(width: AppSizes.w4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.sp11,
              color: AppColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
