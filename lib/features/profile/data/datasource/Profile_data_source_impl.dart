import 'package:dio/dio.dart';
import 'package:habispace/core/constants/api_constant.dart';
import 'package:habispace/core/constants/dio_helper.dart';
import 'package:habispace/features/profile/data/datasource/Profile_data_source.dart';
import 'package:habispace/features/profile/data/models/user_model.dart';

class ProfileDataSourceImpl implements ProfileDataSource {
  @override
  Future<void> logOut() async {
    await DioHelper.post(path: ApiConstant.logout, withAuth: true);
  }

  @override
  Future<UserModel> getProfileData() async {
    final response = await DioHelper.get(
      path: ApiConstant.getProfile,
      withAuth: true,
    );

    final data = response.data is Map && response.data['data'] != null
        ? response.data['data']
        : response.data;

    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    required String phone,
    required String location,
    String? imagePath,
  }) async {
    final Response response;

    if (imagePath != null) {
      final formData = FormData.fromMap({
        'name': name,
        'phone': phone,
        'location': location,
        'image': await MultipartFile.fromFile(imagePath),
        '_method': 'PUT',
      });
      response = await DioHelper.postFormData(
        path: ApiConstant.updateProfile,
        formData: formData,
        withAuth: true,
      );
    } else {
      response = await DioHelper.put(
        path: ApiConstant.updateProfile,
        withAuth: true,
        data: {'name': name, 'phone': phone, 'location': location},
      );
    }

    // validateStatus accepts all codes — check manually
    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      final msg = response.data is Map
          ? (response.data['message'] ??
                response.data['error'] ??
                'Update failed (status $status)')
          : 'Update failed (status $status)';
      throw Exception(msg.toString());
    }

    final data = response.data is Map && response.data['data'] != null
        ? response.data['data']
        : response.data;
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteProfile() {
    return DioHelper.delete(path: ApiConstant.deleteAccount, withAuth: true);
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
