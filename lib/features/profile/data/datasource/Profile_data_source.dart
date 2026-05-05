  import 'package:habispace/features/profile/data/models/user_model.dart';

abstract class ProfileDataSource {
    Future<UserModel> getProfileData();

    Future<void> deleteAccount();

    Future<UserModel> updateProfile({
        required String name,
        required String phone,
        required String location,
    });
}