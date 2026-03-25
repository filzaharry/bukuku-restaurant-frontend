import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as getx;
import 'dart:developer' as developer;
import 'storage_service.dart';

class ApiHandler extends getx.GetxService {
  late Dio dio;

  @override
  void onInit() {
    super.onInit();
    // Use 10.0.2.2 for Android Emulator, or literal IP for real devices/iOS
    final baseUrl = dotenv.get('API_BASE_URL', fallback: 'http://10.0.2.2:8000/api/v1');

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status! < 500;
      },
    ));

    // Auth Interceptor to add token automatically
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = StorageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    // Custom Logger that prints everything even if it's long
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('--> ${options.method} ${options.uri}');
        print('Headers: ${options.headers}');
        if (options.data != null) {
          if (options.data is FormData) {
            print('Body: FormData (Fields: ${(options.data as FormData).fields})');
          } else {
            print('Body: ${options.data}');
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('<-- ${response.statusCode} ${response.requestOptions.uri}');
        print('Response: ${response.data}');

        // Handle 422 validation errors with errors array
        if (response.statusCode == 422 && response.data is Map) {
          final data = response.data as Map;
          if (data.containsKey('errors') && data['errors'] is List) {
            final errors = data['errors'] as List;
            for (final error in errors) {
              if (error is String) {
                getx.Get.snackbar(
                  'Validation Error',
                  error,
                  backgroundColor: getx.Get.theme.colorScheme.error,
                  colorText: getx.Get.theme.colorScheme.onError,
                  snackPosition: getx.SnackPosition.BOTTOM,
                );
              }
            }
          }
        }

        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('<-- ERROR ${e.requestOptions.uri}');
        print('Message: ${e.message}');
        if (e.response != null) {
          print('Error Data: ${e.response?.data}');
        }
        print("error dari backend");
        print(e.response?.data);
        return handler.next(e);
      },
    ));
  }

  Future<Response> request(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isMultipart = false,
  }) async {
    try {
      Options options = Options(method: method);

      if (isMultipart && data is Map<String, dynamic>) {
        data = FormData.fromMap(data);
      }

      return await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      print('DioException on ${method} ${path}');
      print('Status Code: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print("error dari backend");
      rethrow;
    } catch (e) {
      print("error dari backend");
      throw Exception('Unexpected error: $e');
    }
  }

  // Helper methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) => request(path, method: 'GET', queryParameters: queryParameters);

  Future<Response> post(String path, {dynamic data, bool isMultipart = false}) => request(path, method: 'POST', data: data, isMultipart: isMultipart);

  Future<Response> put(String path, {dynamic data, bool isMultipart = false}) => request(path, method: 'PUT', data: data, isMultipart: isMultipart);

  Future<Response> delete(String path, {dynamic data}) => request(path, method: 'DELETE', data: data);
}
