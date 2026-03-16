import 'package:get/get.dart';
import '../../../core/services/api_handler.dart';
import '../models/pos_item_model.dart';

class PosRepository {
  final ApiHandler _apiHandler = Get.find<ApiHandler>();

  Future<Map<String, dynamic>> fetchItems({int page = 1, int limit = 10, int? categoryId}) async {
    Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };
    if (categoryId != null && categoryId != -1) {
      queryParams['category_id'] = categoryId;
    }

    final response = await _apiHandler.get('/pos/item/list', queryParameters: queryParams);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data']['data'] ?? [];
      final List<PosItemModel> items = data.map((e) => PosItemModel.fromJson(e)).toList();
      
      final dynamic pagination = response.data['data']['pagination'];
      final int totalPage = pagination?['totalPage'] ?? 1;
      
      return {
        'items': items,
        'totalPage': totalPage,
      };
    }
    throw Exception(response.data['message'] ?? 'Failed to fetch items');
  }

  Future<List<PosCategoryModel>> fetchCategories() async {
    final response = await _apiHandler.get('/pos/categories');
    if (response.statusCode == 200 && response.data['data'] != null) {
      final List<dynamic> catList = response.data['data']['data'] ?? [];
      return catList.map((e) => PosCategoryModel.fromJson(e)).toList();
    }
    throw Exception(response.data['message'] ?? 'Failed to fetch categories');
  }
}
