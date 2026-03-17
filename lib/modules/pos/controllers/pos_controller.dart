import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_handler.dart';
import '../../../routes/app_pages.dart';
import '../models/pos_item_model.dart';
import '../repositories/pos_repository.dart';

class PosController extends GetxController {
  final ApiHandler _apiHandler = Get.find<ApiHandler>();
  late final PosRepository _repository;

  final RxList<PosCategoryModel> categories = <PosCategoryModel>[].obs;
  final RxList<PosItemModel> items = <PosItemModel>[].obs;

  final RxMap<int, CartItemModel> cart = <int, CartItemModel>{}.obs;
  final RxInt selectedCategoryId = (-1).obs;

  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingItems = false.obs;
  final RxBool isLoadMore = false.obs;

  final RxList<Map<String, dynamic>> tables = <Map<String, dynamic>>[].obs;
  final RxnInt selectedTableId = RxnInt(null);

  int currentPage = 1;
  int totalPage = 1;
  final int limit = 10;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _repository = PosRepository();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadMoreItems();
      }
    });

    fetchCategories();
    fetchItems(isRefresh: true);
    fetchTables();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    try {
      final data = await _repository.fetchCategories();
      categories.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchTables() async {
    try {
      final response = await _apiHandler.get('/pos/dropdown/fnb-table');
      if (response.statusCode == 200 && response.data['data'] != null) {
        tables.value = List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tables: $e');
    }
  }

  Future<void> fetchItems({bool isRefresh = false}) async {
    if (isLoadingItems.value || isLoadMore.value) return;

    if (isRefresh) {
      currentPage = 1;
      items.clear();
      isLoadingItems.value = true;
    } else {
      isLoadMore.value = true;
    }

    try {
      final result = await _repository.fetchItems(page: currentPage, limit: limit, categoryId: selectedCategoryId.value == -1 ? null : selectedCategoryId.value);

      final List<PosItemModel> newItems = result['items'];
      totalPage = result['totalPage'];

      if (isRefresh) {
        items.value = newItems;
      } else {
        items.addAll(newItems);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch items: $e');
    } finally {
      isLoadingItems.value = false;
      isLoadMore.value = false;
    }
  }

  void loadMoreItems() {
    if (isLoadingItems.value || isLoadMore.value || currentPage >= totalPage) return;
    currentPage++;
    fetchItems();
  }

  void selectCategory(int id) {
    if (selectedCategoryId.value == id) return; // ignore same selection
    selectedCategoryId.value = id;
    fetchItems(isRefresh: true);
  }

  void addToCart(PosItemModel item) {
    if (cart.containsKey(item.id)) {
      cart[item.id]!.quantity++;
      cart.refresh();
    } else {
      cart[item.id] = CartItemModel(item: item, quantity: 1);
    }
  }

  void removeFromCart(int itemId) {
    if (cart.containsKey(itemId)) {
      if (cart[itemId]!.quantity > 1) {
        cart[itemId]!.quantity--;
        cart.refresh();
      } else {
        cart.remove(itemId);
      }
    }
  }

  double get subtotal {
    double total = 0.0;
    for (var cartItem in cart.values) {
      total += cartItem.item.price * cartItem.quantity;
    }
    return total;
  }

  int get cartCount {
    int count = 0;
    for (var cartItem in cart.values) {
      count += cartItem.quantity;
    }
    return count;
  }

  // Checkout
  final customerName = ''.obs;
  final customerPhone = ''.obs;
  final RxBool isSubmitting = false.obs;

  void navigateToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  Future<void> placeOrder() async {
    print('--- placeOrder started ---');
    if (cart.isEmpty) {
      Get.snackbar('Error', 'Cart is empty');
      return;
    }

    if (customerName.value.isEmpty || customerPhone.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in your name and phone number');
      return;
    }

    if (selectedTableId.value == null) {
      Get.snackbar('Error', 'Please select a table');
      return;
    }

    isSubmitting.value = true;
    try {
      final List<Map<String, dynamic>> orderItems = [];

      cart.forEach((itemId, cartItem) {
        orderItems.add({
          'fnb_id': itemId,
          'quantity': cartItem.quantity,
        });
      });

      final payload = {
        'table_id': selectedTableId.value,
        'customer_name': customerName.value,
        'customer_phone': customerPhone.value,
        'payment_method': 0,
        'items': orderItems,
      };

      final response = await _apiHandler.post('/pos/order', data: payload);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Clear cart and form
        cart.clear();
        customerName.value = '';
        customerPhone.value = '';
        selectedTableId.value = null;

        Get.back(); // Close bottom sheet

        Get.dialog(
          AlertDialog(
            title: const Icon(Icons.check_circle, color: Colors.green, size: 64),
            content: const Text('Pesanan anda berhasil dibuat', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            actions: [TextButton(onPressed: () => Get.back(), child: const Text('OK'))],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar('Error', 'Failed to place order. Code: ${response.statusCode}. Message: ${response.data['message']}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
}
