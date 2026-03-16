class PosCategoryModel {
  final int id;
  final String name;

  PosCategoryModel({required this.id, required this.name});

  factory PosCategoryModel.fromJson(Map<String, dynamic> json) {
    return PosCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class PosItemModel {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;
  final int status;
  final PosCategoryModel? category;

  PosItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.status,
    this.category,
  });

  factory PosItemModel.fromJson(Map<String, dynamic> json) {
    return PosItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] != null ? int.tryParse(json['price'].toString()) ?? 0 : 0,
      image: json['image'] ?? '',
      status: json['status'] != null ? int.tryParse(json['status'].toString()) ?? 0 : 0,
      category: json['category'] != null ? PosCategoryModel.fromJson(json['category']) : null,
    );
  }
}

class CartItemModel {
  final PosItemModel item;
  int quantity;

  CartItemModel({required this.item, this.quantity = 1});
}
