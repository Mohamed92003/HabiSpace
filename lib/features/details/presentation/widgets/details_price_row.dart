import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habispace/core/constants/images_pathes.dart';
import 'package:habispace/core/shared/custom_svg.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import '../../../favorite/presentation/cubit/FavoriteCubit/favorite_cubit_state.dart';
import '../../domain/entities/property_detail_entity.dart';

class DetailsPriceRow extends StatelessWidget {
  final PropertyDetailEntity property;
  final String priceFormatted;

  const DetailsPriceRow({
    super.key,
    required this.property,
    required this.priceFormatted,
  });

  @override
  Widget build(BuildContext context) {
    final isForSale = property.listingType == 'sale';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '\$$priceFormatted',
          style: TextStyle(
            fontSize: AppSizes.sp22,
            fontWeight: FontWeight.w800,
            color: AppColors.secondBlack,
          ),
        ),
        SizedBox(width: AppSizes.w6),
        Text(
          '\u00b7',
          style: TextStyle(
            color: AppColors.textLightColor,
            fontSize: AppSizes.sp18,
          ),
        ),
        SizedBox(width: AppSizes.w6),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w10,
            vertical: AppSizes.h5,
          ),
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(AppSizes.r20),
            border: Border.all(color: AppColors.blue, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSvgImage(
                path: ImagesPathes.sale,
                width: AppSizes.w12,
                height: AppSizes.h12,
                color: AppColors.blue,
              ),
              SizedBox(width: AppSizes.w4),
              Text(
                isForSale
                    ? AppTexts.forSaleLabel.tr()
                    : AppTexts.forRentLabel.tr(),
                style: TextStyle(
                  fontSize: AppSizes.sp12,
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
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
                isFav ? Icons.star_rounded : Icons.star_border_rounded,
                size: AppSizes.h28,
                color: isFav ? Colors.amber : AppColors.secondaryColor,
              ),
            );
          },
        ),
      ],
    );
  }
}
