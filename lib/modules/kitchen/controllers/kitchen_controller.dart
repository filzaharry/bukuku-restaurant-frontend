import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/kitchen_repository.dart';

class KitchenController extends GetxController {
  final KitchenRepository repository = Get.put(KitchenRepository());

  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // Filtered orders by status
  List<Map<String, dynamic>> get pendingOrders => 
      orders.where((order) => order['status'] == 'pending').toList();
  
  List<Map<String, dynamic>> get readyOrders => 
      orders.where((order) => order['status'] == 'ready').toList();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    
    // Auto refresh every 30 seconds
    ever(orders, (_) {});
    refreshPeriodically();
  }

  void refreshPeriodically() {
    Future.delayed(const Duration(seconds: 30), () {
      if (Get.context != null) {
        fetchOrders();
        refreshPeriodically();
      }
    });
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await repository.getOrders();

      if (response.statusCode == 200) {
        orders.assignAll(response.data ?? []);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      final response = await repository.updateOrderStatus(orderId, status);

      Get.back(); // Close loading

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Order status updated successfully");
        fetchOrders(); // Refresh orders
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  void refreshOrders() {
    fetchOrders();
  }
}
