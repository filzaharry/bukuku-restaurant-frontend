import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../components/ui_scaffold.dart';
import '../../../core/models/order_model.dart';
import '../controllers/kitchen_controller.dart';

class KitchenView extends GetView<KitchenController> {
  const KitchenView({super.key});

  @override
  Widget build(BuildContext context) {
    return UiScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kitchen Monitor",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: controller.refreshOrders,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.orders.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text("No active kitchen orders", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: controller.orders.length,
                itemBuilder: (context, index) {
                  return _buildKitchenCard(controller.orders[index], index);
                },
              );
            }),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildKitchenCard(OrderModel order, int index) {
    // Variety of colors for header based on index
    final List<Color> headerColors = [
      const Color(0xFFFF8A65), // Orange
      const Color(0xFFFFF176), // Yellow
      const Color(0xFFAED581), // Light Green
      const Color(0xFF81C784), // Green
    ];
    final Color headerColor = headerColors[index % headerColors.length];

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Table ${order.tableId ?? '?'}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('h:mm a').format(order.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.6)),
                    ),
                    Text(
                      order.customerName,
                      style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: order.details?.length ?? 0,
              itemBuilder: (context, itemIndex) {
                final item = order.details![itemIndex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item.quantity} x ",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: Text(
                              item.fnbName,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      if (item.level.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            item.level.first.name,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      if (item.extras.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            item.extras.map((e) => e.name).join(', '),
                            style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateOrderStatus(order.id, 2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("MARK DONE", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
