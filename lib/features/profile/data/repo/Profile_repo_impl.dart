import 'package:habispace/features/profile/data/datasource/Profile_data_source_impl.dart';
import 'package:habispace/features/profile/domain/Repository/Profile_repo.dart';
import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';

import '../../../../core/constants/secure_storage.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileDataSourceImpl repo;

  ProfileRepoImpl({required this.repo});

  @override
  Future<void> logOut() async {
    await SecureStorage().remove(SecureKeys.token);
    return await repo.logOut();
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await repo.deleteProfile();
      await SecureStorage().remove(SecureKeys.token);
    } catch (e) {
     throw Exception('Failed to delete account: $e');
    }
  }

  @override
  Future<ProfileEntity> getProfileData() async {
    return await repo.getProfileData();
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
    required String location,
  }) =>
      repo.updateProfile(name: name, phone: phone, location: location);


  @override
  Future<String> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) =>
      repo.changePassword(
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

}
