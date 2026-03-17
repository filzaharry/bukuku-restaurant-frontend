import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../repositories/register_repository.dart';

class RegisterController extends GetxController {
  final RegisterRepository _repository = RegisterRepository();

  final usernameController = TextEditingController();
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isRePasswordVisible = false.obs;
  final isLoading = false.obs;

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

  /// Validate form fields
  bool _validateForm() {
    String username = usernameController.text.trim();
    String fullname = fullnameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String rePassword = rePasswordController.text;

    if (username.isEmpty) {
      Get.snackbar('Error', 'Username is required', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (fullname.isEmpty) {
      Get.snackbar('Error', 'Full name is required', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (phone.isEmpty) {
      Get.snackbar('Error', 'Phone number is required', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email is required', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Error', 'Password is required', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (rePassword.isEmpty) {
      Get.snackbar('Error', 'Please retype your password', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (password != rePassword) {
      Get.snackbar('Error', 'Passwords do not match', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    // Basic email validation
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    return true;
  }

  /// Register user with API
  Future<void> register() async {
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      String username = usernameController.text.trim();
      String fullname = fullnameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text;

      final response = await _repository.register(
        username: username,
        fullname: fullname,
        email: email,
        phone: phone,
        password: password,
      );

      Get.back(); // Close loading dialog

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          response.message ?? 'Registration successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to login after successful registration
        Future.delayed(const Duration(seconds: 2), () {
          Get.offNamed(Routes.LOGIN);
        });
      } else {
        // Close loading dialog on error response
        isLoading.value = false;

        // Handle validation errors
        if (response.data != null && response.data is Map) {
          final errors = response.data as Map;
          if (errors.containsKey('errors') && errors['errors'] is List) {
            final errorList = errors['errors'] as List;
            for (String error in errorList) {
              Get.snackbar('Validation Error', error, backgroundColor: Colors.orange, colorText: Colors.white);
            }
          } else {
            Get.snackbar(
              'Error',
              response.message ?? 'Registration failed',
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Error',
            response.message ?? 'Registration failed',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear all form fields
  void _clearForm() {
    usernameController.clear();
    fullnameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    rePasswordController.clear();

    // Reset password visibility
    isPasswordVisible.value = false;
    isRePasswordVisible.value = false;
  }

  /// Check email availability (optional feature)
  Future<void> checkEmailAvailability() async {
    String email = emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      return;
    }

    final isAvailable = await _repository.checkEmailAvailability(email);
    if (!isAvailable) {
      Get.snackbar('Info', 'Email is already registered', backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  /// Check phone availability (optional feature)
  Future<void> checkPhoneAvailability() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      return;
    }

    final isAvailable = await _repository.checkPhoneAvailability(phone);
    if (!isAvailable) {
      Get.snackbar('Info', 'Phone number is already registered', backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  void goToLogin() {
    Get.offNamed(Routes.LOGIN); // Navigate to login and clear previous route
  }
}
