import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/ui_table.dart';
import '../../../../components/ui_pagination.dart';
import '../../../../components/ui_table_layout.dart';
import '../controllers/category_controller.dart';

import '../../../../components/ui_scaffold.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return UiScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() => UiTableLayout(
              title: "Item Categories",
              onSearch: controller.onSearch,
              onCreate: controller.createCategory,
              onFilter: controller.openFilter,
              table: UiTable(
                isLoading: controller.isLoading.value,
                columns: const ["ID", "Name", "Status", "Actions"],
                columnWidths: const {
                  0: FixedColumnWidth(80),
                  1: FlexColumnWidth(3),
                  2: FixedColumnWidth(100),
                  3: FixedColumnWidth(120),
                },
                rows: controller.categories
                    .map((item) => [
                          Text("#${item.id}"),
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
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
                                onPressed: () => controller.editCategory(item),
                                icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                              ),
                              IconButton(
                                onPressed: () => controller.deleteCategory(item),
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
