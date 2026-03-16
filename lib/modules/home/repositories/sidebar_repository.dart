import 'package:get/get.dart';
import '../../../core/services/api_handler.dart';
import '../../../core/models/base_response.dart';
import '../../../core/models/menu_model.dart';

class SidebarRepository {
  final ApiHandler apiHandler = Get.find<ApiHandler>();

  Future<BaseResponse<List<MenuModel>>> getMenus(int roleId) async {
    final response = await apiHandler.get('/util/sidebar/$roleId');

    return BaseResponse<List<MenuModel>>.fromJson(
      response.data,
      (json) => (json as List).map((x) => MenuModel.fromJson(x)).toList(),
    );
  }
}
