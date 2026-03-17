import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/models/table_model.dart';
import '../../../../core/models/pagination_meta.dart';
import '../../../../components/ui_text_input.dart';
import '../../../../components/ui_dropdown.dart';
import '../../../../components/ui_button.dart';
import '../repositories/table_repository.dart';

class TableController extends GetxController {
  final TableRepository repository = Get.put(TableRepository());

  final tables = <TableModel>[].obs;
  final isLoading = false.obs;
  final meta = Rxn<PaginationMeta>();
  final searchQuery = "".obs;

  // Form Fields
  final nameController = TextEditingController();
  final statusValue = 0.obs; // 0: Available, 1: Unavailable

  @override
  void onInit() {
    super.onInit();
    fetchTables();
  }

  Future<void> fetchTables({int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await repository.getTables(
        page: page,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );

      if (response.statusCode == 200) {
        tables.assignAll(response.data ?? []);
        meta.value = response.meta;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String value) {
    searchQuery.value = value;
    fetchTables();
  }

  void onPageChanged(int page) {
    fetchTables(page: page);
  }

  void createTableDialog() {
    nameController.clear();
    statusValue.value = 0;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add New Table",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              UiTextInput(
                label: "Table Name",
                hint: "Example: Table 01",
                controller: nameController,
              ),
              const SizedBox(height: 16),
              Obx(() => UiDropdown<int>(
                    label: "Status",
                    hint: "Select status",
                    value: statusValue.value,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text("Available")),
                      DropdownMenuItem(value: 1, child: Text("Unavailable")),
                    ],
                    onChanged: (val) => statusValue.value = val ?? 0,
                  )),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  UiButton(
                    label: "Save",
                    width: 100,
                    onPressed: submitTable,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitTable() async {
    if (nameController.text.isEmpty) {
      Get.snackbar("Error", "Table name is required");
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      final response = await repository.createTable({
        'name': nameController.text,
        'status': statusValue.value,
      });

      Get.back(); // Close loading

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back(); // Close dialog
        Get.snackbar("Success", "Table created successfully");
        fetchTables();
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  void editTableDialog(TableModel table) {
    nameController.text = table.name;
    statusValue.value = table.status;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Table",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              UiTextInput(
                label: "Table Name",
                hint: "Example: Table 01",
                controller: nameController,
              ),
              const SizedBox(height: 16),
              Obx(() => UiDropdown<int>(
                    label: "Status",
                    hint: "Select status",
                    value: statusValue.value,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text("Available")),
                      DropdownMenuItem(value: 1, child: Text("Unavailable")),
                    ],
                    onChanged: (val) => statusValue.value = val ?? 0,
                  )),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  UiButton(
                    label: "Update",
                    width: 100,
                    onPressed: () => updateTable(table.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateTable(int id) async {
    if (nameController.text.isEmpty) {
      Get.snackbar("Error", "Table name is required");
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      final response = await repository.updateTable(id, {
        'name': nameController.text,
        'status': statusValue.value,
      });

      Get.back(); // Close loading

      if (response.statusCode == 200) {
        Get.back(); // Close dialog
        Get.snackbar("Success", "Table updated successfully");
        fetchTables();
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> deleteTable(TableModel table) async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '${table.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      final response = await repository.deleteTable(table.id);

      Get.back(); // Close loading

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Table deleted successfully");
        fetchTables();
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  void openFilter() {
    Get.snackbar("Info", "Filter functionality would go here");
  }
}
