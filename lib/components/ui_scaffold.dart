import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../modules/home/controllers/home_controller.dart';
import 'ui_sidebar.dart';

class UiScaffold extends StatelessWidget {
  final Widget body;
  final String? title;

  const UiScaffold({
    super.key,
    required this.body,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure HomeController is initialized because Sidebar and AppBar depend on it
    final controller = Get.isRegistered<HomeController>() 
        ? Get.find<HomeController>() 
        : Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Bukuku Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(() => Text(
                          controller.userName.value,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        )),
                    Obx(() => Text(
                          controller.userRole.value,
                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                        )),
                  ],
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const UiSidebar(),
      body: body,
    );
  }
}
