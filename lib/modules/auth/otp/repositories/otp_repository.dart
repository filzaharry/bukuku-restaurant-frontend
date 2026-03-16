import 'package:get/get.dart';

import '../../../../core/models/base_response.dart';
import '../../../../core/services/api_handler.dart';

class OtpRepository {
  final ApiHandler apiHandler = Get.find<ApiHandler>();

  Future<BaseResponse<Map<String, dynamic>>> verifyOtp({
    required String code,
    required String email,
    required String purpose,
  }) async {
    final response = await apiHandler.post('/auth/verify-otp', data: {
      "otp": code,
      "email": email,
      "purpose": purpose,
    });

    return BaseResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }
}
