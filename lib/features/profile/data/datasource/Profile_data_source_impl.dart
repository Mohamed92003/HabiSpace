 import 'package:habispace/core/constants/api_constant.dart';
import 'package:habispace/core/constants/dio_helper.dart';
import 'package:habispace/features/profile/data/datasource/Profile_data_source.dart';
import 'package:habispace/features/profile/data/models/user_model.dart';

class ProfileDataSourceImpl implements ProfileDataSource{
  @override
  Future<void> deleteAccount() async{
    await DioHelper.post(path: ApiConstant.deleteAccount, withAuth: true);

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

}