  import 'package:habispace/features/profile/data/models/user_model.dart';

abstract class ProfileDataSource {
    Future<UserModel> getProfileData();

    Future<void> logOut();

    Future<UserModel> updateProfile({
        required String name,
        required String phone,
        required String location,
    });

    Future<void> deleteProfile();


    Future<String> changePassword({
        required String currentPassword,
        required String password,
        required String passwordConfirmation,
    });
}