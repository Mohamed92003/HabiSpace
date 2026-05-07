import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../domain/entities/review_entity.dart';
import '../cubit/details_cubit.dart';

class DetailsReviewsSection extends StatelessWidget {
  final List<ReviewEntity> reviews;
  final List<String> images;
  final int propertyId;

  const DetailsReviewsSection({
    super.key,
    required this.reviews,
    required this.images,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    final avgRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTexts.userReviews.tr(),
              style: TextStyle(
                fontSize: AppSizes.sp16,
                fontWeight: FontWeight.w700,
                color: AppColors.secondBlack,
              ),
            ),
            GestureDetector(
              onTap: () => context.pushNamed(
                AppRoutes.reviews,
                extra: {
                  'propertyId': propertyId,
                  'propertyTitle': '',
                  'detailsCubit': context.read<DetailsCubit>(),
                },
              ),
              child: Text(
                AppTexts.seeAll.tr(),
                style: TextStyle(
                  fontSize: AppSizes.sp13,
                  color: AppColors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.h8),
        if (reviews.isNotEmpty) ...[

          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: AppColors.yellow,
                size: AppSizes.h18,
              ),
              SizedBox(width: AppSizes.w4),
              Text(
                '${avgRating.toStringAsFixed(1)} (${reviews.length} ${AppTexts.rating.tr()})',
                style: TextStyle(
                  fontSize: AppSizes.sp13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondBlack,
                ),
              ),
              SizedBox(width: AppSizes.w8),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.textLightColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppSizes.w8),
              Text(
                '${reviews.length} ${AppTexts.reviews.tr()}',
                style: TextStyle(
                  fontSize: AppSizes.sp13,
                  color: AppColors.textSecondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h12),
          if (images.isNotEmpty) ...[
            _ImageThumbnails(images: images),
            SizedBox(height: AppSizes.h16),
          ],
          ...reviews
              .take(2)
              .map(
                (r) => Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.h16),
                  child: ReviewCard(review: r),
                ),
              ),
        ] else
          GestureDetector(
            onTap: () => context.pushNamed(
              AppRoutes.reviews,
              extra: {
                'propertyId': propertyId,
                'propertyTitle': '',
                'detailsCubit': context.read<DetailsCubit>(),
              },
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppSizes.h14),
              decoration: BoxDecoration(
                color: AppColors.bluelight,
                borderRadius: BorderRadius.circular(AppSizes.r14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    color: AppColors.blue,
                    size: AppSizes.h18,
                  ),
                  SizedBox(width: AppSizes.w8),
                  Text(
                    AppTexts.beFirstToReview.tr(),
                    style: TextStyle(
                      fontSize: AppSizes.sp14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ImageThumbnails extends StatelessWidget {
  final List<String> images;
  const _ImageThumbnails({required this.images});

  @override
  Widget build(BuildContext context) {
    const maxVisible = 4;
    final extra = images.length > maxVisible ? images.length - maxVisible : 0;
    final shown = images.take(maxVisible).toList();

    return Row(
      children: List.generate(shown.length, (i) {
        final isLast = i == shown.length - 1 && extra > 0;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: i < shown.length - 1 ? AppSizes.w6 : 0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: shown[i],
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.borderColor,
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.textLightColor,
                          size: AppSizes.h24,
                        ),
                      ),
                    ),
                  ),
                  if (isLast)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            '+$extra',
                            style: TextStyle(
                              color: AppColors.light,
                              fontSize: AppSizes.sp16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: AppSizes.w20,
              backgroundColor: AppColors.blue.withValues(alpha: 0.15),
              backgroundImage:
                  (review.userAvatar != null &&
                      review.userAvatar!.startsWith('http'))
                  ? NetworkImage(review.userAvatar!)
                  : null,
              child:
                  (review.userAvatar == null ||
                      !review.userAvatar!.startsWith('http'))
                  ? Text(
                      review.userName.isNotEmpty
                          ? review.userName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: AppSizes.sp14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: AppSizes.w10),
            Expanded(
              child: Text(
                review.userName,
                style: TextStyle(
                  fontSize: AppSizes.sp14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondBlack,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.h8),
        Row(
          children: [
            ...List.generate(
              5,
              (i) => Icon(
                i < review.rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: AppSizes.h16,
                color: AppColors.yellow,
              ),
            ),
            SizedBox(width: AppSizes.w6),
            Text(
              '${review.rating}/5',
              style: TextStyle(
                fontSize: AppSizes.sp12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondBlack,
              ),
            ),
            SizedBox(width: AppSizes.w8),
            Text(
              review.createdAt,
              style: TextStyle(
                fontSize: AppSizes.sp12,
                color: AppColors.textLightColor,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.h8),
        Text(
          review.comment,
          style: TextStyle(
            fontSize: AppSizes.sp13,
            color: AppColors.textSecondaryColor,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
