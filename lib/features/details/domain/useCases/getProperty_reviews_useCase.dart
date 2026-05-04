import 'package:dartz/dartz.dart';
import '../../../../core/error/app_exception.dart';
import '../details_repo/details_repo.dart';
import '../entities/review_entity.dart';

class GetPropertyReviewsUseCase {
  final DetailsRepo repo;

  GetPropertyReviewsUseCase(this.repo);

  Future<Either<AppException, List<ReviewEntity>>> call(int id) {
    return repo.getPropertyReviews(id);
  }
}