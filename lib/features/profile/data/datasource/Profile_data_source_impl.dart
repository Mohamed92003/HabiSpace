 import 'package:habispace/core/constants/api_constant.dart';
import 'package:habispace/core/constants/dio_helper.dart';
import 'package:habispace/features/profile/data/datasource/Profile_data_source.dart';
import 'package:habispace/features/profile/data/models/user_model.dart';

class ProfileDataSourceImpl implements ProfileDataSource{
  @override
  Future<void> logOut() async{
    await DioHelper.post(path: ApiConstant.logout, withAuth: true);

  }

  @override
  Future<UserModel> getProfileData() async {
    final response = await DioHelper.get(
      path: ApiConstant.getProfile,
      withAuth: true,
    );

    print('Profile API Response: ${response.data}');

    final data = response.data is Map && response.data['data'] != null
        ? response.data['data']
        : response.data;

    print('Profile data to parse: $data');

    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    required String phone,
    required String location,
  }) async {
    final response = await DioHelper.put(
      path: ApiConstant.updateProfile,
      withAuth: true,
      data: {'name': name, 'phone': phone, 'location': location},
    );
    final data = response.data is Map && response.data['data'] != null
        ? response.data['data']
        : response.data;
    return UserModel.fromJson(data);
  }

  @override
  Future<void> deleteProfile() {
    return DioHelper.delete(
      path: ApiConstant.deleteAccount,
      withAuth: true,
    );

  }

  @override
  Future<String> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await DioHelper.put(
      path: ApiConstant.changePassword,
      withAuth: true,
      data: {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response.data['message'] ?? 'Password updated.';
  }
}