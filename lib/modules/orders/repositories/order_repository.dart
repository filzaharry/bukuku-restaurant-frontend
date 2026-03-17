import 'package:get/get.dart';
import '../../../core/models/base_response.dart';
import '../../../core/models/order_model.dart';
import '../../../core/services/api_handler.dart';

class OrderRepository {
  final ApiHandler apiHandler = Get.find<ApiHandler>();

  Future<BaseResponse<List<OrderModel>>> getOrders({
    int page = 1,
    String? search,
  }) async {
    final response = await apiHandler.get('/fnb/order', queryParameters: {
      'page': page,
      if (search != null) 'search': search,
    });

    return BaseResponse<List<OrderModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List).map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList(),
      hasMeta: true,
    );
  }

  Future<BaseResponse<OrderModel>> getOrderDetail(int id) async {
    final response = await apiHandler.get('/fnb/order/$id');
    return BaseResponse<OrderModel>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => OrderModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<dynamic>> updateStatus(int id, int status) async {
    final response = await apiHandler.get('/fnb/order/$id/$status');
    return BaseResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data,
    );
  }

  Future<BaseResponse<List<OrderModel>>> getKitchenOrders({
    int page = 1,
    String? search,
  }) async {
    final response = await apiHandler.get('/fnb/kitchen', queryParameters: {
      'page': page,
      if (search != null) 'search': search,
    });

    return BaseResponse<List<OrderModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List).map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList(),
      hasMeta: true,
    );
  }
}
