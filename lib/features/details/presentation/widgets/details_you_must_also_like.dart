import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_color.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../../../home/domain/entities/home_property_entity.dart';

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
        const Text(
          'You Must Also Like',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.secondBlack,
          ),
        ),
        const SizedBox(height: 12),
        ...properties.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
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
                        SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: p.images.isNotEmpty
                              ? Image.network(
                                  p.images[0],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(color: AppColors.borderColor),
                                )
                              : Container(color: AppColors.borderColor),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.sell_outlined,
                                  size: 12,
                                  color: AppColors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  p.listingType == 'sale'
                                      ? 'For Sale'
                                      : 'For a Rent',
                                  style: const TextStyle(
                                    fontSize: 11,
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
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.title,
                                  style: const TextStyle(
                                    fontSize: 15,
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
                                      size: 22,
                                      color: isFav
                                          ? Colors.amber
                                          : AppColors.secondaryColor,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: AppColors.blue,
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  p.address,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  '|',
                                  style: TextStyle(
                                    color: AppColors.borderColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.near_me_outlined,
                                size: 13,
                                color: AppColors.blue,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                '150 miles',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\$${_formatPrice(p.price)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.secondBlack,
                                      ),
                                    ),
                                    if (p.listingType != 'sale')
                                      const TextSpan(
                                        text: '/month',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondaryColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '4.8',
                                    style: TextStyle(
                                      fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textLightColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
