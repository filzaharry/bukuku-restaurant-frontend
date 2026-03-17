import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../components/ui_title.dart';
import '../../../../components/ui_button.dart';
import '../../../../components/ui_text_input.dart';
import '../../../../components/ui_card.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: UiCard(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: UiTitle(
                    text: 'Login',
                    fontSize: 28,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Welcome back, please login to your account',
                    style: TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
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
                const SizedBox(height: 32),
                Obx(() => UiButton(
                      label: 'Login',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.login,
                    )),
                const SizedBox(height: 16),
                Obx(() => UiButton(
                      label: 'Sign in with Google',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.signInWithGoogle,
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                      icon: Icons.g_mobiledata,
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: controller.goToRegister,
                      child: const Text(
                        'Register here',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: controller.goToApp,
                      child: const Text(
                        'Back to Resto App',
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
