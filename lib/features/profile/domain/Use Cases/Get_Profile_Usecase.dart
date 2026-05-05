import 'package:habispace/features/profile/domain/Repository/Profile_repo.dart';
import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';

class GetProfileUsecase {
  final ProfileRepo repository;

  GetProfileUsecase({required this.repository});

  Future<ProfileEntity> call() async {
   return  repository.getProfileData();
  }


}


