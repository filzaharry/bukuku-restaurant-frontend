import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../models/pos_item_model.dart';
import '../controllers/pos_controller.dart';
import 'package:intl/intl.dart';

class PosView extends GetView<PosController> {
  const PosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bukuku POS', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: controller.navigateToLogin,
              icon: const Icon(Icons.login),
              label: const Text('Login'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Side: Categories and Items
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories
                _buildCategories(),

                // Items Grid
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingItems.value && controller.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.items.isEmpty) {
                      return const Center(child: Text('No items available.'));
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            controller: controller.scrollController,
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: controller.items.length,
                            itemBuilder: (context, index) {
                              final item = controller.items[index];
                              return _buildItemCard(item);
                            },
                          ),
                        ),
                        if (controller.isLoadMore.value)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),

          // Right Side: Cart
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(-2, 0)),
              ],
            ),
            child: _buildCart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.white,
      child: Obx(() {
        if (controller.isLoadingCategories.value) {
          return const Center(child: LinearProgressIndicator());
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length + 1, // +1 for "All Categories"
          itemBuilder: (context, index) {
            String name = 'All Categories';
            int id = -1;

            if (index > 0) {
              final cat = controller.categories[index - 1];
              name = cat.name;
              id = cat.id;
            }

            final isSelected = controller.selectedCategoryId.value == id;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(name),
                selected: isSelected,
                onSelected: (bool selected) {
                  controller.selectCategory(id);
                },
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildItemCard(PosItemModel item) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => controller.addToCart(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Placeholder (or actual image)
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: item.image.isNotEmpty
                    ? Image.network(
                        'http://10.0.2.2:8000/storage/' + item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                      )
                    : const Icon(Icons.fastfood, size: 50, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.isEmpty ? '-' : item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(item.price),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCart(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Column(
      children: [
        // Cart Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Current Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Obx(() => CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 16,
                    child: Text('${controller.cartCount}', style: const TextStyle(color: Colors.white, fontSize: 14)),
                  )),
            ],
          ),
        ),
        const Divider(height: 1),

        // Cart Items
        Expanded(
          child: Obx(() {
            if (controller.cart.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Your order is empty', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.cart.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                int itemId = controller.cart.keys.elementAt(index);
                CartItemModel cartItem = controller.cart[itemId]!;

                return Row(
                  children: [
                    // Quantity Control
                    Column(
                      children: [
                        InkWell(
                          onTap: () => controller.addToCart(cartItem.item),
                          child: const Icon(Icons.add_circle_outline, color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text('${cartItem.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        InkWell(
                          onTap: () => controller.removeFromCart(itemId),
                          child: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Item details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cartItem.item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(currencyFormatter.format(cartItem.item.price), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    // Item Total
                    Text(
                      currencyFormatter.format(cartItem.item.price * cartItem.quantity),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            );
          }),
        ),

        // Cart Footer (Total & Checkout)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
            ],
          ),
          child: Column(
            children: [
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                      Text(currencyFormatter.format(controller.subtotal), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tax (11%)', style: TextStyle(color: Colors.grey)),
                  Obx(() => Text(currencyFormatter.format(controller.subtotal * 0.11), style: const TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        currencyFormatter.format(controller.subtotal * 1.11),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.cart.isEmpty) {
                      Get.snackbar('Cart Empty', 'Please add items First.');
                      return;
                    }
                    _showCheckoutBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCheckoutBottomSheet(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Checkout Order', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
                    ],
                  ),
                  const Divider(thickness: 1, height: 32),

                  // Form
                  Expanded(
                    child: ListView(
                      children: [
                        const Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Customer Name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                          onChanged: (val) => controller.customerName.value = val,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)),
                          keyboardType: TextInputType.phone,
                          onChanged: (val) => controller.customerPhone.value = val,
                        ),
                        const SizedBox(height: 16),
                        Obx(() => DropdownButtonFormField<int>(
                              decoration: const InputDecoration(labelText: 'Table', border: OutlineInputBorder(), prefixIcon: Icon(Icons.table_restaurant)),
                              value: controller.selectedTableId.value,
                              items: controller.tables.map((table) {
                                return DropdownMenuItem<int>(
                                  value: table['id'] as int,
                                  child: Text(table['name'].toString()),
                                );
                              }).toList(),
                              onChanged: (val) {
                                controller.selectedTableId.value = val;
                              },
                            )),

                        const SizedBox(height: 32),
                        const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        // Summary Items
                        ...controller.cart.entries.map((entry) {
                          CartItemModel cartItem = entry.value;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text('${cartItem.quantity}x ${cartItem.item.name}')),
                                Text(currencyFormatter.format(cartItem.item.price * cartItem.quantity)),
                              ],
                            ),
                          );
                        }).toList(),

                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              currencyFormatter.format(controller.subtotal * 1.11), // Included tax 11%
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Submit Button
                  Obx(() => SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: controller.isSubmitting.value
                              ? null
                              : () {
                                  controller.placeOrder();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: controller.isSubmitting.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Submit Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      )),
                ],
              ));
        });
  }
}
