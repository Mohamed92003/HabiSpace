part of 'details_cubit.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final PropertyDetailEntity property;
  final List<ReviewEntity> reviews;
  final bool isSubmittingReview;

  DetailsLoaded({
    required this.property,
    required this.reviews,
    this.isSubmittingReview = false,
  });

  DetailsLoaded copyWith({
    PropertyDetailEntity? property,
    List<ReviewEntity>? reviews,
    bool? isSubmittingReview,
  }) => DetailsLoaded(
    property: property ?? this.property,
    reviews: reviews ?? this.reviews,
    isSubmittingReview: isSubmittingReview ?? this.isSubmittingReview,
  );
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}

class ReviewSubmitError extends DetailsState {
  final String message;
  final PropertyDetailEntity property;
  final List<ReviewEntity> reviews;
  ReviewSubmitError(this.message, this.property, this.reviews);
}
