import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isRePasswordVisible = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    fullnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRePasswordVisibility() {
    isRePasswordVisible.value = !isRePasswordVisible.value;
  }

  void register() {
    // Mock validation
    String username = usernameController.text.trim();
    String fullname = fullnameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String rePassword = rePasswordController.text;

    if (username.isEmpty || fullname.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || rePassword.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (password != rePassword) {
      Get.snackbar('Error', 'Passwords do not match', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    Get.snackbar('Success', 'Registration logic started. Redirecting to OTP...');
    Get.toNamed(Routes.OTP, arguments: {
      'email': email,
      'purpose': 'register',
    });
  }

  void goToLogin() {
    Get.back();
  }
}
