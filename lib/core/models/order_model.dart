class OrderModel {
  final int id;
  final String orderNumber;
  final String customerName;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? "",
      customerName: json['customer_name'] ?? "",
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      status: json['status'] ?? "pending",
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
