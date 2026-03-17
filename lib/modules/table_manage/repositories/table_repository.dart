import 'package:get/get.dart';
import '../../../../core/models/base_response.dart';
import '../../../../core/models/table_model.dart';
import '../../../../core/services/api_handler.dart';

class TableRepository {
  final ApiHandler apiHandler = Get.find<ApiHandler>();

  Future<BaseResponse<List<TableModel>>> getTables({
    int page = 1,
    String? search,
  }) async {
    final response = await apiHandler.get('/fnb/table', queryParameters: {
      'page': page,
      if (search != null) 'search': search,
    });

    return BaseResponse<List<TableModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List).map((e) => TableModel.fromJson(e as Map<String, dynamic>)).toList(),
      hasMeta: true,
    );
  }

  Future<BaseResponse<TableModel>> createTable(Map<String, dynamic> data) async {
    final response = await apiHandler.post('/fnb/table', data: data);
    return BaseResponse<TableModel>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => TableModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<TableModel>> updateTable(int id, Map<String, dynamic> data) async {
    final response = await apiHandler.post('/fnb/table/$id', data: data);
    return BaseResponse<TableModel>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => TableModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<void>> deleteTable(int id) async {
    final response = await apiHandler.delete('/fnb/table/$id');
    return BaseResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => null,
    );
  }
}
