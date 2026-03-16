import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/ui_alert.dart';
import '../../../../components/ui_button.dart';
import '../../../../components/ui_text_input.dart';
import '../../../../components/ui_title.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/models/pagination_meta.dart';
import '../repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository repository = Get.put(CategoryRepository());

  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;
  final meta = Rxn<PaginationMeta>();
  final searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories({int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await repository.getCategories(
        page: page,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );

      print('123123123123');
      print(response.data);

      if (response.statusCode == 200) {
        categories.assignAll(response.data ?? []);
        meta.value = response.meta;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String value) {
    searchQuery.value = value;
    fetchCategories();
  }

  void onPageChanged(int page) {
    fetchCategories(page: page);
  }

  void createCategory() {
    final TextEditingController nameController = TextEditingController();
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
              const UiTitle(text: "Create Category", fontSize: 18),
              const SizedBox(height: 16),
              UiTextInput(
                label: "Category Name",
                hint: "Enter category name",
                controller: nameController,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: UiButton(
                      label: "Save",
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty) return;
                        Get.back();
                        isLoading.value = true;
                        final res = await repository.createCategory(name: nameController.text.trim());
                        isLoading.value = false;
                        if (res.statusCode == 201 || res.statusCode == 200) {
                          fetchCategories(page: meta.value?.currentPage ?? 1);
                        } else {
                          UiAlert.error(res.message);
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void editCategory(CategoryModel category) {
    final TextEditingController nameController = TextEditingController(text: category.name);
    final RxInt status = category.status.obs;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UiTitle(text: "Edit Category", fontSize: 18),
                  const SizedBox(height: 16),
                  UiTextInput(
                    label: "Category Name",
                    hint: "Enter category name",
                    controller: nameController,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Status",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: status.value,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Active")),
                      DropdownMenuItem(value: 0, child: Text("Inactive")),
                    ],
                    onChanged: (val) {
                      if (val != null) status.value = val;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: UiButton(
                          label: "Save",
                          onPressed: () async {
                            if (nameController.text.trim().isEmpty) return;
                            Get.back();
                            isLoading.value = true;
                            final res = await repository.updateCategory(
                              id: category.id,
                              name: nameController.text.trim(),
                              status: status.value,
                            );
                            isLoading.value = false;
                            if (res.statusCode == 200) {
                              fetchCategories(page: meta.value?.currentPage ?? 1);
                            } else {
                              UiAlert.error(res.message);
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  void deleteCategory(CategoryModel category) {
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
              const UiTitle(text: "Delete Category", fontSize: 18),
              const SizedBox(height: 16),
              Text("Are you sure you want to delete '${category.name}'?"),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: UiButton(
                      label: "Delete",
                      backgroundColor: Colors.red,
                      onPressed: () async {
                        Get.back();
                        isLoading.value = true;
                        final res = await repository.deleteCategory(category.id);
                        isLoading.value = false;
                        if (res.statusCode == 200) {
                          fetchCategories(page: meta.value?.currentPage ?? 1);
                        } else {
                          UiAlert.error(res.message);
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void openFilter() {
    Get.snackbar("Info", "Filter functionality would go here");
  }
}
