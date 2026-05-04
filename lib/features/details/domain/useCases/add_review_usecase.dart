import 'package:dartz/dartz.dart';
import '../../../../core/error/app_exception.dart';
import '../details_repo/details_repo.dart';
import '../entities/review_entity.dart';

class AddReviewUseCase {
  final DetailsRepo repo;
  AddReviewUseCase(this.repo);

  Future<Either<AppException, ReviewEntity>> call(
    int propertyId,
    int rating,
    String comment,
  ) => repo.addReview(propertyId, rating, comment);
}
