import 'package:habispace/features/profile/domain/entities/Profile_Entity.dart';

abstract class ProfileRepo {
  Future<ProfileEntity> getProfileData();
   Future<void> deleteAccount();
  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
    required String location,
  });
}
