  import 'package:habispace/features/profile/data/models/user_model.dart';

abstract class ProfileDataSource {
    Future<UserModel> getProfileData();

    Future<void> deleteAccount();
}