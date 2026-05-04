import 'package:dartz/dartz.dart';
import '../../../../core/error/app_exception.dart';
import '../details_repo/details_repo.dart';
import '../entities/property_detail_entity.dart';

class GetPropertyDetailUseCase {
  final DetailsRepo repo;

  GetPropertyDetailUseCase(this.repo);

  Future<Either<AppException, PropertyDetailEntity>> call(int id) {
    return repo.getPropertyDetail(id);
  }
}