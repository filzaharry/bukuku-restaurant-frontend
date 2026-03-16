import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/ui_alert.dart';
import '../../../../core/utils/device_util.dart';
import '../../../../routes/app_pages.dart';
import '../repositories/login_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Inject Repository
  final LoginRepository loginRepository = Get.find<LoginRepository>();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      UiAlert.error('Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      final deviceData = await DeviceUtil.getDeviceInfo();

      // Call Repository instead of direct API Service
      final baseResponse = await loginRepository.login(email: email, password: password, device: deviceData);

      if (baseResponse.statusCode == 200 || baseResponse.statusCode == 201) {
        UiAlert.success(baseResponse.message, onConfirm: () {
          if (baseResponse.data?.nextStep == 'verify_otp') {
            Get.toNamed(Routes.OTP, arguments: {
              'email': email,
              'purpose': 'login',
            });
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        });
      } else {
        UiAlert.error(baseResponse.message);
      }
    } on dio.DioException catch (e) {
      String message = "An error occurred";
      if (e.type == dio.DioExceptionType.connectionError) {
        message = "Cannot connect to server. Check your connection or API URL.";
      } else if (e.response?.data != null && e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
      }
      UiAlert.error(message);
    } catch (e) {
      UiAlert.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      // We must pass the Web Client ID from env to serverClientId 
      // otherwise Android won't generate an idToken outside of Firebase automatically.
      final String? webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        print("Google Sign In aborted: account is null");
        return; // User canceled
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        UiAlert.error('Failed to get Google ID Token');
        return;
      }

      final deviceData = await DeviceUtil.getDeviceInfo();
      final baseResponse = await loginRepository.googleLogin(
        token: idToken,
        device: deviceData,
      );

      if (baseResponse.statusCode == 200 || baseResponse.statusCode == 201) {
        UiAlert.success(baseResponse.message, onConfirm: () {
          Get.offAllNamed(Routes.HOME);
        });
      } else {
        UiAlert.error(baseResponse.message);
      }
    } on dio.DioException catch (e) {
      String message = "An error occurred";
      if (e.type == dio.DioExceptionType.connectionError) {
        message = "Cannot connect to server. Check your connection or API URL.";
      } else if (e.response?.data != null && e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
      }
      UiAlert.error(message);
    } catch (e) {
      UiAlert.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
