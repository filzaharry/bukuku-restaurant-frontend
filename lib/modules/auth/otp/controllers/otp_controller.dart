import 'dart:convert';

import 'package:get/get.dart';

import '../../../../components/ui_alert.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_pages.dart';
import '../repositories/otp_repository.dart';

class OtpController extends GetxController {
  final otpRepository = Get.put(OtpRepository());
  final otpCode = "".obs;
  final isLoading = false.obs;

  void onOtpCompleted(String code) {
    otpCode.value = code;
  }

  Future<void> verify() async {
    if (otpCode.value.length != 6) {
      UiAlert.error('Please enter a valid 6-digit OTP code');
      return;
    }

    try {
      isLoading.value = true;
      final response = await otpRepository.verifyOtp(
        code: otpCode.value,
        email: Get.arguments['email'],
        purpose: Get.arguments['purpose'],
      );

      if (response.statusCode == 200) {
        // Save token to SharedPreferences as requested
        final token = response.data?['token'];
        if (token != null) {
          await StorageService.saveToken(token);
        }

        UiAlert.success(response.message, onConfirm: () {
          Get.offAllNamed(Routes.HOME);
        });
      } else {
        UiAlert.error(response.message);
      }
    } catch (e) {
      UiAlert.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() {
    UiAlert.success('OTP code has been resent to your email/phone');
  }
}
