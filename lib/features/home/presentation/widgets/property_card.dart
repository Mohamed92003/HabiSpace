import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../../domain/entities/home_property_entity.dart';

class PropertyCard extends StatelessWidget {
  final HomePropertyEntity property;

  const PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: Container(
        width: AppSizes.w220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: property.images.isNotEmpty
                      ? SizedBox(
                          height: AppSizes.h140,
                          width: AppSizes.w220,
                          child: Image.network(
                            property.images[0],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/Frame 2147228697.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Image.asset(
                          'assets/images/Frame 2147228697.png',
                          fit: BoxFit.cover,
                          height: AppSizes.h140,
                          width: AppSizes.w220,
                        ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.w8, vertical: AppSizes.h6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
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
                          property.listingType == 'sale' ? 'For Sale' : 'For Rent',
                          style: TextStyle(
                            fontSize: AppSizes.sp12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.w12, vertical: AppSizes.h10),
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
                            color: AppColors.black,
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
                              color: isFav ? Colors.amber : AppColors.black,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: AppSizes.h14, color: AppColors.blue),
                      SizedBox(width: AppSizes.w2),
                      Expanded(
                        child: Text(
                          property.address,
                          style: TextStyle(fontSize: AppSizes.sp12, color: Colors.grey.shade500),
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
                          color: AppColors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: AppSizes.h16, color: Colors.amber),
                          SizedBox(width: AppSizes.w2),
                          Text(
                            '4.9',
                            style: TextStyle(
                              fontSize: AppSizes.sp12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
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
