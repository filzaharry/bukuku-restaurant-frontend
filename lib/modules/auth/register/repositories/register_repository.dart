import 'dart:convert';

import 'package:get/get.dart';
import '../../../../core/services/api_handler.dart';
import '../../../../core/models/base_response.dart';

class RegisterRepository {
  final ApiHandler _apiHandler = Get.find<ApiHandler>();

  /// Register new user
  Future<BaseResponse> register({
    required String username,
    required String fullname,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      print('Register Request: {username: $username, fullname: $fullname, email: $email, phone: $phone}');

      final response = await _apiHandler.post(
        '/auth/register',
        data: {
          'username': username,
          'fullname': fullname,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      print('Register Response: statusCode=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 201) {
        return BaseResponse(
          statusCode: response.data['statusCode'],
          message: response.data['message'],
          data: response.data['data'],
        );
      } else {
        return BaseResponse(
          statusCode: response.statusCode ?? 500,
          message: 'Registration failed',
          data: null,
        );
      }
    } catch (e) {
      print('Register Error: ${e.toString()}');
      return BaseResponse(
        statusCode: 500,
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Check if email is available
  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await _apiHandler.post(
        '/auth/check-email',
        data: {'email': email},
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Check if phone is available
  Future<bool> checkPhoneAvailability(String phone) async {
    try {
      final response = await _apiHandler.post(
        '/auth/check-phone',
        data: {'phone': phone},
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
