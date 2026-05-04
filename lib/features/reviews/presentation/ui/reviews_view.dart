import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../details/presentation/cubit/details_cubit.dart';
import '../../../details/presentation/widgets/details_reviews_section.dart';

class ReviewsView extends StatefulWidget {
  final int propertyId;
  final String propertyTitle;

  const ReviewsView({
    super.key,
    required this.propertyId,
    required this.propertyTitle,
  });

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  @override
  void initState() {
    super.initState();
    final state = context.read<DetailsCubit>().state;
    if (state is! DetailsLoaded) {
      context.read<DetailsCubit>().loadDetails(widget.propertyId);
    }
  }

  void _showAddReviewSheet() {
    int selectedRating = 0;
    final commentController = TextEditingController();
    final cubit = context.read<DetailsCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: StatefulBuilder(
          builder: (ctx, setSheetState) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSizes.h24,
              top: AppSizes.h24,
              left: AppSizes.w20,
              right: AppSizes.w20,
            ),
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.r24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: AppSizes.w40,
                    height: AppSizes.h4,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.circular(AppSizes.r2),
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.h20),
                Text(
                  AppTexts.writeReview.tr(),
                  style: TextStyle(
                    fontSize: AppSizes.sp18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondBlack,
                  ),
                ),
                SizedBox(height: AppSizes.h16),
                Text(
                  AppTexts.yourRating.tr(),
                  style: TextStyle(
                    fontSize: AppSizes.sp13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                SizedBox(height: AppSizes.h8),
                Row(
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedRating = i + 1),
                      child: Padding(
                        padding: EdgeInsets.only(right: AppSizes.w6),
                        child: Icon(
                          i < selectedRating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: AppSizes.h38,
                          color: i < selectedRating
                              ? Colors.amber
                              : AppColors.borderColor,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: AppSizes.h16),
                Text(
                  AppTexts.yourComment.tr(),
                  style: TextStyle(
                    fontSize: AppSizes.sp13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                SizedBox(height: AppSizes.h8),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: AppTexts.shareYourExperience.tr(),
                    hintStyle: TextStyle(
                      color: AppColors.textLightColor,
                      fontSize: AppSizes.sp13,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGrayColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(AppSizes.h14),
                  ),
                ),
                SizedBox(height: AppSizes.h20),
                BlocBuilder<DetailsCubit, DetailsState>(
                  builder: (context, state) {
                    final isSubmitting =
                        state is DetailsLoaded && state.isSubmittingReview;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                if (selectedRating == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppTexts.pleaseSelectRating.tr(),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (commentController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppTexts.pleaseWriteComment.tr(),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                await context.read<DetailsCubit>().submitReview(
                                  widget.propertyId,
                                  selectedRating,
                                  commentController.text.trim(),
                                );
                                if (context.mounted) Navigator.pop(ctx);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: AppColors.light,
                          padding: EdgeInsets.symmetric(vertical: AppSizes.h14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.r14),
                          ),
                          elevation: 0,
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                height: AppSizes.h20,
                                width: AppSizes.w20,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                AppTexts.submitReview.tr(),
                                style: TextStyle(
                                  fontSize: AppSizes.sp15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.secondBlack,
            size: AppSizes.h18,
          ),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTexts.userReviews.tr(),
              style: TextStyle(
                fontSize: AppSizes.sp16,
                fontWeight: FontWeight.w700,
                color: AppColors.secondBlack,
              ),
            ),
            if (widget.propertyTitle.isNotEmpty)
              Text(
                widget.propertyTitle,
                style: TextStyle(
                  fontSize: AppSizes.sp11,
                  color: AppColors.textLightColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSizes.w16),
            child: GestureDetector(
              onTap: _showAddReviewSheet,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w12,
                  vertical: AppSizes.h6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(AppSizes.r20),
                ),
                child: Text(
                  AppTexts.addReview.tr(),
                  style: TextStyle(
                    fontSize: AppSizes.sp12,
                    color: AppColors.light,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<DetailsCubit, DetailsState>(
        listener: (context, state) {
          if (state is ReviewSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            );
          }
          if (state is DetailsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: AppSizes.h12),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondaryColor,
                      fontSize: AppSizes.sp13,
                    ),
                  ),
                  SizedBox(height: AppSizes.h16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                    ),
                    onPressed: () => context.read<DetailsCubit>().loadDetails(
                      widget.propertyId,
                    ),
                    child: Text(
                      AppTexts.retry.tr(),
                      style: TextStyle(color: AppColors.light),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is DetailsLoaded) {
            final reviews = state.reviews;
            final avgRating = reviews.isEmpty
                ? 0.0
                : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                      reviews.length;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(AppSizes.w16),
                    padding: EdgeInsets.all(AppSizes.w16),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(AppSizes.r16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              avgRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: AppSizes.sp48,
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondBlack,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  i < avgRating.round()
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  size: AppSizes.h16,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSizes.h4),
                            Text(
                              '${reviews.length} ${AppTexts.reviews.tr()}',
                              style: TextStyle(
                                fontSize: AppSizes.sp12,
                                color: AppColors.textLightColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: AppSizes.w20),
                        Expanded(
                          child: Column(
                            children: List.generate(5, (i) {
                              final star = 5 - i;
                              final count = reviews
                                  .where((r) => r.rating == star)
                                  .length;
                              final fraction = reviews.isEmpty
                                  ? 0.0
                                  : count / reviews.length;
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSizes.h2,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '$star',
                                      style: TextStyle(
                                        fontSize: AppSizes.sp11,
                                        color: AppColors.textSecondaryColor,
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.w4),
                                    Icon(
                                      Icons.star_rounded,
                                      size: AppSizes.h11,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: AppSizes.w6),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.r4,
                                        ),
                                        child: LinearProgressIndicator(
                                          value: fraction,
                                          minHeight: 6,
                                          backgroundColor:
                                              AppColors.borderColor,
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                Colors.amber,
                                              ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.w6),
                                    Text(
                                      '$count',
                                      style: TextStyle(
                                        fontSize: AppSizes.sp11,
                                        color: AppColors.textLightColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (reviews.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: AppSizes.h64,
                            color: AppColors.textLightColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          SizedBox(height: AppSizes.h16),
                          Text(
                            AppTexts.noReviewsYet.tr(),
                            style: TextStyle(
                              fontSize: AppSizes.sp16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryColor,
                            ),
                          ),
                          SizedBox(height: AppSizes.h8),
                          Text(
                            AppTexts.startChatFromListing.tr(),
                            style: TextStyle(
                              fontSize: AppSizes.sp13,
                              color: AppColors.textLightColor,
                            ),
                          ),
                          SizedBox(height: AppSizes.h20),
                          ElevatedButton(
                            onPressed: _showAddReviewSheet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              foregroundColor: AppColors.light,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.r12,
                                ),
                              ),
                            ),
                            child: Text(AppTexts.writeReview.tr()),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ReviewCard(review: reviews[index]),
                        childCount: reviews.length,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: AppSizes.h32)),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
