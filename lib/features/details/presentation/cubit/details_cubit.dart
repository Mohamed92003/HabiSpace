import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/property_detail_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/useCases/add_review_usecase.dart';
import '../../domain/useCases/getProperty_detail_useCase.dart';
import '../../domain/useCases/getProperty_reviews_useCase.dart';
part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final GetPropertyDetailUseCase getPropertyDetailUseCase;
  final GetPropertyReviewsUseCase getPropertyReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;

  DetailsCubit({
    required this.getPropertyDetailUseCase,
    required this.getPropertyReviewsUseCase,
    required this.addReviewUseCase,
  }) : super(DetailsInitial());

  Future<void> loadDetails(int propertyId) async {
    emit(DetailsLoading());
    final detailResult = await getPropertyDetailUseCase(propertyId);
    detailResult.fold((error) => emit(DetailsError(error.message)), (
      property,
    ) async {
      final reviewResult = await getPropertyReviewsUseCase(propertyId);
      final reviews = reviewResult.fold((_) => <ReviewEntity>[], (r) => r);
      emit(DetailsLoaded(property: property, reviews: reviews));
    });
  }

  Future<void> submitReview(int propertyId, int rating, String comment) async {
    final current = state;
    if (current is! DetailsLoaded) return;

    emit(current.copyWith(isSubmittingReview: true));

    final result = await addReviewUseCase(propertyId, rating, comment);

    result.fold(
      (error) {
        emit(
          ReviewSubmitError(error.message, current.property, current.reviews),
        );
        emit(current.copyWith(isSubmittingReview: false));
      },
      (newReview) {
        emit(
          current.copyWith(
            reviews: [newReview, ...current.reviews],
            isSubmittingReview: false,
          ),
        );
      },
    );
  }
}
