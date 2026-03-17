import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/sidebar_repository.dart';
import '../../../core/models/menu_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final sidebarRepository = Get.put(SidebarRepository());
  
  final count = 0.obs;
  final textController = TextEditingController();

  final userName = "Harry Filza".obs;
  final userRole = "Administrator".obs;
  final roleId = 500.obs; // Variable roleId as requested

  final menuList = <MenuModel>[].obs;
  final isMenuLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    try {
      isMenuLoading.value = true;
      final response = await sidebarRepository.getMenus(roleId.value);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data ?? [];
        if (data.isEmpty) {
          handleLogout();
        } else {
          menuList.assignAll(data);
        }
      } else {
        handleLogout();
      }
    } catch (e) {
      debugPrint("Error fetching menus: $e");
      handleLogout();
    } finally {
      isMenuLoading.value = false;
    }
  }

  void handleLogout() {
    StorageService.removeToken();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  void sayHello() {
    Get.snackbar(
      'Hello!',
      'Welcome to Bukuku App: ${textController.text.isNotEmpty ? textController.text : "Guest"}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
    );
  }
}
