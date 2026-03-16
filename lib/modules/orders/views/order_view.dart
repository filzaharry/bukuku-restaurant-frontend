import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/ui_table.dart';
import '../../../components/ui_pagination.dart';
import '../../../components/ui_table_layout.dart';
import '../controllers/order_controller.dart';

import '../../../components/ui_scaffold.dart';

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
          onCreate: controller.createOrder,
          onFilter: controller.openFilter,
          table: UiTable(
            isLoading: controller.isLoading.value,
            columns: const ["Order #", "Customer", "Total", "Status", "Date", "Actions"],
            columnWidths: const {
              0: FixedColumnWidth(100),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1.5),
              5: FixedColumnWidth(100),
            },
            rows: controller.orders.map((item) => [
              Text(item.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(item.customerName),
              Text("Rp ${item.totalAmount}"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.status.toUpperCase(),
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
                  IconButton(onPressed: () {}, icon: const Icon(Icons.visibility, size: 20, color: Colors.blue)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.print, size: 20, color: Colors.grey)),
                ],
              ),
            ]).toList(),
          ),
          pagination: UiPagination(
            meta: controller.meta.value,
            onPageChanged: controller.onPageChanged,
          ),
        )),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
