import 'package:dio/dio.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/constants/dio_helper.dart';
import '../models/property_detail_model.dart';
import '../models/review_model.dart';

abstract class DetailsRemoteDataSource {
  Future<PropertyDetailModel> getPropertyDetail(int id);
  Future<List<ReviewModel>> getPropertyReviews(int id);
  Future<ReviewModel> addReview(int propertyId, int rating, String comment);
}

class DetailsRemoteDataSourceImpl implements DetailsRemoteDataSource {
  @override
  Future<PropertyDetailModel> getPropertyDetail(int id) async {
    final response = await DioHelper.get(
      path: '${ApiConstant.properties}/$id',
      withAuth: true,
    );
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
    return PropertyDetailModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<ReviewModel>> getPropertyReviews(int id) async {
    final response = await DioHelper.get(
      path: '${ApiConstant.properties}/$id/reviews',
    );
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
    final List<dynamic> list =
        (response.data['data'] ?? response.data) as List<dynamic>;
    return list
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ReviewModel> addReview(
    int propertyId,
    int rating,
    String comment,
  ) async {
    final response = await DioHelper.post(
      path: '${ApiConstant.properties}/$propertyId/reviews',
      data: {'rating': rating, 'comment': comment},
      withAuth: true,
    );
    final data = response.data['data'] ?? response.data;
    return ReviewModel.fromJson(data as Map<String, dynamic>);
  }
}
