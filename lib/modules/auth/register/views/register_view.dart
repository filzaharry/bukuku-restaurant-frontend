import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../components/ui_title.dart';
import '../../../../components/ui_button.dart';
import '../../../../components/ui_text_input.dart';
import '../../../../components/ui_card.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: UiCard(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: UiTitle(
                    text: 'Register',
                    fontSize: 28,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Create a new account',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 32),
                UiTextInput(
                  label: 'Username',
                  hint: 'Enter your username',
                  controller: controller.usernameController,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                UiTextInput(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: controller.fullnameController,
                  prefixIcon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                UiTextInput(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: controller.phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                UiTextInput(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: controller.emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                Obx(() => UiTextInput(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: controller.passwordController,
                      prefixIcon: Icons.lock_outline,
                      obscureText: !controller.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => UiTextInput(
                      label: 'Retype Password',
                      hint: 'Retype your password',
                      controller: controller.rePasswordController,
                      prefixIcon: Icons.lock_reset_outlined,
                      obscureText: !controller.isRePasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isRePasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: controller.toggleRePasswordVisibility,
                      ),
                    )),
                const SizedBox(height: 32),
                Obx(() => UiButton(
                      label: controller.isLoading.value ? 'Registering...' : 'Register',
                      onPressed: () => controller.register(),
                      isLoading: controller.isLoading.value,
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
