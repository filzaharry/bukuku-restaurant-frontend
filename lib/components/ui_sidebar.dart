import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../core/services/storage_service.dart';
import '../routes/app_pages.dart';
import '../modules/home/controllers/home_controller.dart';
import '../core/models/menu_model.dart';

class UiSidebar extends GetView<HomeController> {
  const UiSidebar({Key? key}) : super(key: key);

  IconData _getIcon(String? iconName) {
    switch (iconName) {
      case 'ic_home':
        return Icons.dashboard_outlined;
      case 'ic_archive':
        return Icons.inventory_2_outlined;
      case 'ic_kitchen':
        return Icons.restaurant_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primary, size: 40),
            ),
            accountName: Obx(() => Text(
                  controller.userName.value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
            accountEmail: Obx(() => Text(controller.userRole.value)),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isMenuLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.menuList.isEmpty) {
                return const Center(child: Text("No menus available"));
              }

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.menuList.length,
                itemBuilder: (context, index) {
                  final menu = controller.menuList[index];
                  return _buildMenuItem(menu);
                },
              );
            }),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await StorageService.removeToken();
              Get.offAllNamed(Routes.LOGIN);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuModel menu) {
    if (menu.child.isEmpty) {
      return ListTile(
        leading: Icon(_getIcon(menu.icon)),
        title: Text(menu.name),
        onTap: () {
          Get.back(); // Close drawer
          if (menu.url.isNotEmpty) {
            Get.toNamed(menu.url);
          }
        },
      );
    } else {
      return ExpansionTile(
        leading: Icon(_getIcon(menu.icon)),
        title: Text(menu.name),
        children: menu.child.map((child) {
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 32),
            leading: Icon(_getIcon(child.icon), size: 20),
            title: Text(child.name),
            onTap: () {
              Get.back();
              if (child.url.isNotEmpty) {
                Get.toNamed(child.url);
              }
            },
          );
        }).toList(),
      );
    }
  }
}
