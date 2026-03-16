import 'package:frontend/core/models/base_response.dart';
import 'package:frontend/core/models/login_response.dart';
import 'package:frontend/core/services/api_handler.dart';
import 'package:get/get.dart';

class LoginRepository {
  final ApiHandler apiHandler = Get.find<ApiHandler>();

  Future<BaseResponse<LoginData>> login({
    required String email,
    required String password,
    required Map<String, dynamic> device,
  }) async {
    final response = await apiHandler.post('/auth/login', data: {
      "email": email,
      "password": password,
      "device": device,
    });

    return BaseResponse<LoginData>.fromJson(
      response.data,
      (json) => LoginData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<LoginData>> googleLogin({
    required String token,
    required Map<String, dynamic> device,
  }) async {
    final response = await apiHandler.post('/auth/google', data: {
      "token": token,
      "device": device,
    });

    return BaseResponse<LoginData>.fromJson(
      response.data,
      (json) => LoginData.fromJson(json as Map<String, dynamic>),
    );
  }
}
