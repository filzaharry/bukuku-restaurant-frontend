import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/ui_table.dart';
import '../../../components/ui_pagination.dart';
import '../../../components/ui_table_layout.dart';
import '../controllers/order_controller.dart';

import '../../../components/ui_scaffold.dart';
import '../../../core/models/order_model.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return UiScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() => UiTableLayout(
              title: "Orders",
              onSearch: controller.onSearch,
              // onCreate: controller.createOrder,
              onFilter: controller.openFilter,
              table: UiTable(
                isLoading: controller.isLoading.value,
                columns: const ["Order #", "Customer", "Total", "Status", "Date", "Actions"],
                columnWidths: const {
                  0: FixedColumnWidth(200),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1.5),
                  5: FixedColumnWidth(100),
                },
                rows: controller.orders
                    .map((item) => [
                          Text(item.orderCode, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(item.customerName),
                          Text("Rp ${item.total}"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.statusLabel.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getStatusColor(item.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(DateFormat('dd MMM yyyy').format(item.createdAt)),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.fetchOrderDetail(item.id);
                                  _showOrderDetail(context, item);
                                },
                                icon: const Icon(Icons.visibility, size: 20, color: Colors.blue),
                              ),
                            ],
                          ),
                        ])
                    .toList(),
              ),
              pagination: UiPagination(
                meta: controller.meta.value,
                onPageChanged: controller.onPageChanged,
              ),
            )),
      ),
    );
  }

  void _showOrderDetail(BuildContext context, OrderModel order) {
    Get.bottomSheet(
      Obx(() {
        if (controller.isDetailLoading.value) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final detail = controller.selectedOrder.value;
        if (detail == null) {
          return const SizedBox(
            height: 300,
            child: Center(child: Text("Failed to load order details")),
          );
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Detail - ${detail.orderCode}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              _buildInfoRow("Customer", detail.customerName),
              _buildInfoRow("Phone", detail.customerPhone ?? "-"),
              _buildInfoRow("Date", DateFormat('dd MMM yyyy HH:mm').format(detail.createdAt)),
              _buildInfoRow("Status", detail.statusLabel),
              const SizedBox(height: 16),
              const Text("Items", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (detail.details != null)
                ...detail.details!.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.fnbName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                if (item.level.isNotEmpty) Text("Level: ${item.level.first.name}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                if (item.extras.isNotEmpty) Text("Extras: ${item.extras.map((e) => e.name).join(', ')}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text("${item.quantity} x Rp ${item.price}"),
                          const SizedBox(width: 16),
                          Text("Rp ${item.totalPrice}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
              const Divider(),
              _buildInfoRow("Subtotal", "Rp ${detail.subtotal}"),
              _buildInfoRow("Tax", "Rp ${detail.tax}"),
              _buildInfoRow("Total", "Rp ${detail.total}", isBold: true),
              const SizedBox(height: 24),
              const Text("Update Status", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 8),
                  if (detail.status == 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.updateOrderStatus(detail.id, 1),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                        child: const Text("Process"),
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (detail.status == 1)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.updateOrderStatus(detail.id, 2),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        child: const Text("Done"),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 2: // Completed
        return Colors.green;
      case 0: // Pending
        return Colors.blue;
      case 1: // Processing
        return Colors.orange;
      case 3: // Cancelled/Refunded
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
