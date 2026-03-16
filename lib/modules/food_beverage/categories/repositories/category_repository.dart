import 'package:get/get.dart';
import '../../../../core/models/base_response.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/services/api_handler.dart';

class CategoryRepository {
  final ApiHandler apiHandler = Get.find<ApiHandler>();

  Future<BaseResponse<List<CategoryModel>>> getCategories({
    int page = 1,
    String? search,
  }) async {
    final response = await apiHandler.get('/fnb/category', queryParameters: {
      'page': page,
      if (search != null) 'search': search,
    });

    return BaseResponse<List<CategoryModel>>.fromJson(
      response.data,
      (data) => (data as List).map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList(),
      hasMeta: true,
    );
  }

  Future<BaseResponse<CategoryModel>> createCategory({
    required String name,
  }) async {
    final response = await apiHandler.post('/fnb/category', data: {
      'name': name,
    });

    return BaseResponse<CategoryModel>.fromJson(
      response.data,
      (data) => CategoryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<CategoryModel>> updateCategory({
    required int id,
    required String name,
    required int status,
  }) async {
    final response = await apiHandler.post('/fnb/category/$id', data: {
      'name': name,
      'status': status,
    });

    return BaseResponse<CategoryModel>.fromJson(
      response.data,
      (data) => CategoryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<BaseResponse> deleteCategory(int id) async {
    final response = await apiHandler.delete('/fnb/category/$id');

    return BaseResponse.fromJson(
      response.data,
      (data) => null,
    );
  }
}
