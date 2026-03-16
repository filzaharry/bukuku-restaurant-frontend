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
    final response = await apiHandler.get('/orders', queryParameters: {
      'page': page,
      if (search != null) 'search': search,
    });

    return BaseResponse<List<OrderModel>>.fromJson(
      response.data,
      (data) => (data as List).map((e) => OrderModel.fromJson(e)).toList(),
    );
  }
}
