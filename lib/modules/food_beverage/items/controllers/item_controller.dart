import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../core/models/item_model.dart';
import '../../../../core/models/pagination_meta.dart';
import '../../../../core/models/category_model.dart';
import '../../../../components/ui_text_input.dart';
import '../../../../components/ui_dropdown.dart';
import '../../../../components/ui_image_picker.dart';
import '../../../../components/ui_button.dart';
import '../repositories/item_repository.dart';
import '../../categories/controllers/category_controller.dart';

class ItemController extends GetxController {
  final ItemRepository repository = Get.put(ItemRepository());
  final CategoryController categoryController = Get.put(CategoryController());

  final items = <ItemModel>[].obs;
  final isLoading = false.obs;
  final meta = Rxn<PaginationMeta>();
  final searchQuery = "".obs;

  // Form Fields
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final selectedCategory = Rxn<CategoryModel>();
  final selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems({int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await repository.getItems(
        page: page,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );

      if (response.statusCode == 200) {
        items.assignAll(response.data ?? []);
        meta.value = response.meta;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String value) {
    searchQuery.value = value;
    fetchItems();
  }

  void onPageChanged(int page) {
    fetchItems(page: page);
  }

  void createItem() {
    // Reset form
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    selectedCategory.value = null;
    selectedImage.value = null;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Create New Item",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 24),
                UiTextInput(
                  label: "Item Name",
                  hint: "Enter item name",
                  controller: nameController,
                ),
                const SizedBox(height: 16),
                UiTextInput(
                  label: "Description",
                  hint: "Enter item description",
                  controller: descriptionController,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: UiTextInput(
                        label: "Price",
                        hint: "Enter price",
                        controller: priceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() {
                        final items = categoryController.categories
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat.name, overflow: TextOverflow.ellipsis),
                                ))
                            .toList();

                        // Ensure current value is in the items list to avoid crash
                        if (selectedCategory.value != null && !categoryController.categories.any((c) => c.id == selectedCategory.value!.id)) {
                          items.add(DropdownMenuItem(
                            value: selectedCategory.value,
                            child: Text(selectedCategory.value!.name, overflow: TextOverflow.ellipsis),
                          ));
                        }

                        return UiDropdown<CategoryModel>(
                          label: "Category",
                          hint: "Select category",
                          value: selectedCategory.value,
                          items: items,
                          onChanged: (val) => selectedCategory.value = val,
                        );
                      }),
                    ),
                  ],
                ),
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
                      label: "Save Item",
                      width: 130,
                      onPressed: submitItem,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitItem() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || selectedCategory.value == null) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      final Map<String, dynamic> data = {
        'name': nameController.text,
        'description': descriptionController.text,
        'price': priceController.text,
        'category_id': selectedCategory.value!.id,
      };

      if (selectedImage.value != null) {
        data['image'] = await dio.MultipartFile.fromFile(
          selectedImage.value!.path,
          filename: selectedImage.value!.path.split('/').last,
        );
      }

      final response = await repository.storeItem(data);

      Get.back(); // Close loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close dialog
        Get.snackbar(
          "Success",
          "Item created successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        fetchItems();
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

  void editItem(ItemModel item) {
    // Pre-fill form with item data
    nameController.text = item.name;
    descriptionController.text = item.description ?? '';
    priceController.text = item.price.toString();

    // Select from list if exists, otherwise use current
    final foundCategory = categoryController.categories.firstWhereOrNull((c) => c.id == item.category?.id);
    selectedCategory.value = foundCategory ?? item.category;
    selectedImage.value = null; // Reset image, could load existing if needed

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Edit Item",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 24),
                UiTextInput(
                  label: "Item Name",
                  hint: "Enter item name",
                  controller: nameController,
                ),
                const SizedBox(height: 16),
                UiTextInput(
                  label: "Description",
                  hint: "Enter item description",
                  controller: descriptionController,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: UiTextInput(
                        label: "Price",
                        hint: "Enter price",
                        controller: priceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() {
                        final items = categoryController.categories
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat.name, overflow: TextOverflow.ellipsis),
                                ))
                            .toList();

                        // Ensure current value is in the items list to avoid crash
                        if (selectedCategory.value != null && !categoryController.categories.any((c) => c.id == selectedCategory.value!.id)) {
                          items.add(DropdownMenuItem(
                            value: selectedCategory.value,
                            child: Text(selectedCategory.value!.name, overflow: TextOverflow.ellipsis),
                          ));
                        }

                        return UiDropdown<CategoryModel>(
                          label: "Category",
                          hint: "Select category",
                          value: selectedCategory.value,
                          items: items,
                          onChanged: (val) => selectedCategory.value = val,
                        );
                      }),
                    ),
                  ],
                ),
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
                      width: 120,
                      onPressed: () => updateItem(item.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateItem(int itemId) async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || selectedCategory.value == null) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      final Map<String, dynamic> data = {
        'name': nameController.text,
        'description': descriptionController.text,
        'price': priceController.text,
        'category_id': selectedCategory.value!.id,
      };

      if (selectedImage.value != null) {
        data['image'] = await dio.MultipartFile.fromFile(
          selectedImage.value!.path,
          filename: selectedImage.value!.path.split('/').last,
        );
      }

      final response = await repository.updateItem(itemId, data);

      Get.back(); // Close loading

      if (response.statusCode == 200) {
        Get.back(); // Close dialog
        Get.snackbar(
          "Success",
          "Item updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        fetchItems();
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> deleteItem(ItemModel item) async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '${item.name}'?"),
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

      final response = await repository.deleteItem(item.id);

      Get.back(); // Close loading

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Item deleted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        fetchItems();
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
