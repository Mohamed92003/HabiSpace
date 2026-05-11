import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
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
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        final liveReviews = state is DetailsLoaded ? state.reviews : reviews;
        final avgRating = state is DetailsLoaded
            ? state.liveRating
            : (reviews.isEmpty
                  ? 0.0
                  : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                        reviews.length);

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
                    color: context.appTheme.titleText,
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
            if (liveReviews.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: AppColors.yellow,
                    size: AppSizes.h18,
                  ),
                  SizedBox(width: AppSizes.w4),
                  Text(
                    '${avgRating.toStringAsFixed(1)} (${liveReviews.length} ${AppTexts.rating.tr()})',
                    style: TextStyle(
                      fontSize: AppSizes.sp13,
                      fontWeight: FontWeight.w600,
                      color: context.appTheme.titleText,
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
                    '${liveReviews.length} ${AppTexts.reviews.tr()}',
                    style: TextStyle(
                      fontSize: AppSizes.sp13,
                      color: context.appTheme.subtleText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h12),
              if (images.isNotEmpty) ...[
                _ImageThumbnails(images: images),
                SizedBox(height: AppSizes.h16),
              ],
              ...liveReviews
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
      }, // BlocBuilder
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

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      // If it's already short (e.g. "2026-05-10"), just return as-is
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: TextStyle(
                      fontSize: AppSizes.sp14,
                      fontWeight: FontWeight.w600,
                      color: context.appTheme.titleText,
                    ),
                  ),
                  SizedBox(height: AppSizes.h2),
                  Text(
                    _formatDate(review.createdAt),
                    style: TextStyle(
                      fontSize: AppSizes.sp11,
                      color: AppColors.textLightColor,
                    ),
                  ),
                ],
              ),
            ),
            // Rating badge — top right
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w8,
                vertical: AppSizes.h4,
              ),
              decoration: BoxDecoration(
                color: AppColors.yellow.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.r20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: AppSizes.sp13,
                    color: AppColors.yellow,
                  ),
                  SizedBox(width: AppSizes.w2),
                  Text(
                    '${review.rating}',
                    style: TextStyle(
                      fontSize: AppSizes.sp12,
                      fontWeight: FontWeight.w700,
                      color: context.appTheme.titleText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.h8),
        // Star row
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              i < review.rating
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              size: AppSizes.h16,
              color: AppColors.yellow,
            ),
          ),
        ),
        SizedBox(height: AppSizes.h8),
        Text(
          review.comment,
          style: TextStyle(
            fontSize: AppSizes.sp13,
            color: context.appTheme.bodyText,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: AppSizes.h16),
        Divider(color: context.appTheme.divider, height: 1),
        SizedBox(height: AppSizes.h8),
      ],
    );
  }
}
