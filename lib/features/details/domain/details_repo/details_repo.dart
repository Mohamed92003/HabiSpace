import 'package:dartz/dartz.dart';
import '../../../../core/error/app_exception.dart';
import '../entities/property_detail_entity.dart';
import '../entities/review_entity.dart';

abstract class DetailsRepo {
  Future<Either<AppException, PropertyDetailEntity>> getPropertyDetail(int id);
  Future<Either<AppException, List<ReviewEntity>>> getPropertyReviews(int id);
  Future<Either<AppException, ReviewEntity>> addReview(
    int propertyId,
    int rating,
    String comment,
  );
}
