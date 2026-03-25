import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/order_model.dart';
import '../../orders/repositories/order_repository.dart';

class KitchenController extends GetxController {
  final OrderRepository repository = Get.put(OrderRepository());

  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();

    // Auto refresh every 30 seconds
    refreshPeriodically();
  }

  void refreshPeriodically() {
    Future.delayed(const Duration(seconds: 30), () {
      if (!isClosed) {
        fetchOrders();
        refreshPeriodically();
      }
    });
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await repository.getKitchenOrders();

      if (response.statusCode == 200) {
        orders.assignAll(response.data ?? []);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(int orderId, int status) async {
    try {
      isLoading.value = true;
      final response = await repository.updateStatus(orderId, status);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Order status updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        fetchOrders(); // Refresh orders
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void refreshOrders() {
    fetchOrders();
  }
}
