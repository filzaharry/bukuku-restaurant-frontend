import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/ui_table.dart';
import '../../../../components/ui_pagination.dart';
import '../../../../components/ui_table_layout.dart';
import '../controllers/item_controller.dart';

import '../../../../components/ui_scaffold.dart';

class ItemView extends GetView<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return UiScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() => UiTableLayout(
              title: "F&B Items",
              onSearch: controller.onSearch,
              onCreate: controller.createItem,
              onFilter: controller.openFilter,
              table: UiTable(
                isLoading: controller.isLoading.value,
                columns: const ["ID", "Name", "Category", "Price", "Status", "Actions"],
                columnWidths: const {
                  0: FixedColumnWidth(80),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1.5),
                  4: FixedColumnWidth(100),
                  5: FixedColumnWidth(150),
                },
                rows: controller.items
                    .map((item) => [
                          Text("#${item.id}"),
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(item.category?.name ?? "-"),
                          Text("Rp ${item.price}"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.status == 1 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.status == 1 ? "Active" : "Inactive",
                              style: TextStyle(
                                color: item.status == 1 ? Colors.green : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => controller.editItem(item),
                                icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                              ),
                              IconButton(
                                onPressed: () => controller.deleteItem(item),
                                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
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
}
