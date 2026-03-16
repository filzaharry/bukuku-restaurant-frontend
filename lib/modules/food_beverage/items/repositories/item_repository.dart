import 'package:get/get.dart';
import '../../../../core/models/base_response.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/models/pagination_meta.dart';
import '../../../../core/services/api_handler.dart';

class ItemRepository {
  final ApiHandler apiHandler = Get.find<ApiHandler>();

  Future<BaseResponse<List<ItemModel>>> getItems({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final response = await apiHandler.get('/fnb/menu', queryParameters: {
      'page': page,
      'limit': limit,
      if (search != null) 'search': search,
    });

    final responseData = response.data;
    final dataObject = responseData['data'];

    // Extract list and pagination from the 'data' field since they are nested
    final List list = dataObject['data'] ?? [];
    final pagination = dataObject['pagination'];

    return BaseResponse<List<ItemModel>>(
      statusCode: responseData['statusCode'] ?? 200,
      message: responseData['message'] ?? "",
      data: list.map((e) => ItemModel.fromJson(e)).toList(),
      meta: pagination != null ? PaginationMeta.fromJson(pagination) : null,
    );
  }

  Future<BaseResponse<ItemModel>> storeItem(Map<String, dynamic> data) async {
    final response = await apiHandler.post('/fnb/menu', data: data, isMultipart: true);

    final responseData = response.data;
    return BaseResponse<ItemModel>(
      statusCode: responseData['statusCode'] ?? 200,
      message: responseData['message'] ?? "",
      data: responseData['data'] != null ? ItemModel.fromJson(responseData['data']) : null,
    );
  }

  Future<BaseResponse<ItemModel>> updateItem(int id, Map<String, dynamic> data) async {
    final response = await apiHandler.post('/fnb/menu/$id', data: data, isMultipart: true);

    final responseData = response.data;
    return BaseResponse<ItemModel>(
      statusCode: responseData['statusCode'] ?? 200,
      message: responseData['message'] ?? "",
      data: responseData['data'] != null ? ItemModel.fromJson(responseData['data']) : null,
    );
  }

  Future<BaseResponse<void>> deleteItem(int id) async {
    final response = await apiHandler.delete('/fnb/menu/$id');

    final responseData = response.data;
    return BaseResponse<void>(
      statusCode: responseData['statusCode'] ?? 200,
      message: responseData['message'] ?? "",
    );
  }
}
