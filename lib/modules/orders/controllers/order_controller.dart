import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/pagination_meta.dart';
import '../repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository repository = Get.put(OrderRepository());

  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final meta = Rxn<PaginationMeta>();
  final searchQuery = "".obs;
  final selectedOrder = Rxn<OrderModel>();
  final isDetailLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders({int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await repository.getOrders(
        page: page,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );

      print("response.data");
      print(response.data);

      if (response.statusCode == 200) {
        orders.assignAll(response.data ?? []);
        meta.value = response.meta;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String value) {
    searchQuery.value = value;
    fetchOrders();
  }

  void onPageChanged(int page) {
    fetchOrders(page: page);
  }

  void createOrder() {
    Get.snackbar("Info", "Create Order functionality would go here");
  }

  void openFilter() {
    Get.snackbar("Info", "Filter functionality would go here");
  }

  Future<void> fetchOrderDetail(int id) async {
    try {
      isDetailLoading.value = true;
      final response = await repository.getOrderDetail(id);
      if (response.statusCode == 200) {
        selectedOrder.value = response.data;
      }
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(int id, int status) async {
    try {
      isLoading.value = true;
      final response = await repository.updateStatus(id, status);
      if (response.statusCode == 200) {
        Get.back();
        fetchOrders();
        Get.snackbar(
          "Success",
          "Order status updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
