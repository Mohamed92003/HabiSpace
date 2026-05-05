import 'package:habispace/features/profile/data/datasource/Profile_data_source_impl.dart';
import 'package:habispace/features/profile/domain/Repository/Profile_repo.dart';
import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';

import '../../../../core/constants/secure_storage.dart';

class ProfileRepoImpl implements ProfileRepo{
  final ProfileDataSourceImpl repo;
  ProfileRepoImpl({required this.repo});

  @override
  Future<void> deleteAccount()async {
    await SecureStorage().remove( SecureKeys.token);
   return await  repo.deleteAccount();
  }

  @override
  Future<ProfileEntity> getProfileData()async {
    return await  repo.getProfileData();
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
    required String location,
  }) =>
      repo.updateProfile(name: name, phone: phone, location: location);

}