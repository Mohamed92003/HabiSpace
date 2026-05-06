import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';

abstract class ProfileRepo {
  Future<ProfileEntity> getProfileData();
   Future<void> logOut();
  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
    required String location,
  });
  Future<void> deleteAccount();

  Future<String> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  });
}
