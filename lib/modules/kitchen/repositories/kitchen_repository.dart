import 'package:get/get.dart';
import '../../../../core/models/base_response.dart';
import '../../../../core/services/api_handler.dart';

class KitchenRepository {
  final ApiHandler apiHandler = Get.find<ApiHandler>();

  Future<BaseResponse<List<Map<String, dynamic>>>> getOrders() async {
    final response = await apiHandler.get('/fnb/order');
    
    final responseData = response.data;
    final dataObject = responseData['data'];
    
    // Extract list and pagination from the 'data' field since they are nested
    final List list = dataObject['data'] ?? [];

    return BaseResponse<List<Map<String, dynamic>>>(
      statusCode: responseData['statusCode'] ?? 200,
      message: responseData['message'] ?? "",
      data: list.cast<Map<String, dynamic>>(),
    );
  }

  Future<BaseResponse<void>> updateOrderStatus(int orderId, String status) async {
    final response = await apiHandler.post('/fnb/order/$orderId/$status');
    
    final responseData = response.data;
    return BaseResponse<void>(
      statusCode: responseData['statusCode'] ?? 200,
      message: responseData['message'] ?? "",
    );
  }
}
