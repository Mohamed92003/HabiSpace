import 'package:dartz/dartz.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/details_repo/details_repo.dart';
import '../../domain/entities/property_detail_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../datasource/details_remote_datasource.dart';

class DetailsRepoImpl implements DetailsRepo {
  final DetailsRemoteDataSource dataSource;

  DetailsRepoImpl(this.dataSource);

  @override
  Future<Either<AppException, PropertyDetailEntity>> getPropertyDetail(
    int id,
  ) async {
    try {
      final result = await dataSource.getPropertyDetail(id);
      return Right(result);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<AppException, List<ReviewEntity>>> getPropertyReviews(
    int id,
  ) async {
    try {
      final result = await dataSource.getPropertyReviews(id);
      return Right(result);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<AppException, ReviewEntity>> addReview(
    int propertyId,
    int rating,
    String comment,
  ) async {
    try {
      final result = await dataSource.addReview(propertyId, rating, comment);
      return Right(result);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
