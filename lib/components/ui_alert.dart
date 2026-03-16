import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import 'ui_button.dart';
import 'ui_title.dart';

class UiAlert {
  static void show({
    required String message,
    bool isError = false,
    String? title,
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (isError ? Colors.red : Colors.green).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isError ? Icons.priority_high : Icons.check,
                  color: isError ? Colors.red : Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              UiTitle(
                text: title ?? (isError ? "Oops!" : "Success"),
                fontSize: 20,
                color: isError ? Colors.red : AppColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              UiButton(
                label: 'Close',
                backgroundColor: isError ? Colors.red : AppColors.primary,
                onPressed: () {
                  Get.back();
                  if (onConfirm != null) onConfirm();
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void success(String message, {VoidCallback? onConfirm}) {
    show(message: message, isError: false, onConfirm: onConfirm);
  }

  static void error(String message, {VoidCallback? onConfirm}) {
    show(message: message, isError: true, onConfirm: onConfirm);
  }
}
