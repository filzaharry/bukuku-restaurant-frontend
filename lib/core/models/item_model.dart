import 'category_model.dart';

class ItemModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final CategoryModel? category;

  ItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    this.category,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['image'],
      category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
    );
  }
}
