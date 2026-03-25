class OrderModel {
  final int id;
  final String? tableId;
  final String orderCode;
  final String customerName;
  final String? customerPhone;
  final double subtotal;
  final double tax;
  final double total;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<OrderDetailModel>? details;

  OrderModel({
    required this.id,
    this.tableId,
    required this.orderCode,
    required this.customerName,
    this.customerPhone,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.details,
  });

  String get statusLabel {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Processing';
      case 2:
        return 'Completed';
      case 3:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      tableId: json['table_id'],
      orderCode: json['order_code'] ?? "",
      customerName: json['customer_name'] ?? "",
      customerPhone: json['customer_phone'],
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0,
      tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      details: json['details'] != null ? (json['details'] as List).map((e) => OrderDetailModel.fromJson(e as Map<String, dynamic>)).toList() : null,
    );
  }
}

class OrderDetailModel {
  final int fnbId;
  final String fnbName;
  final String? fnbImage;
  final int quantity;
  final double price;
  final double totalPrice;
  final List<OrderLevelModel> level;
  final List<OrderExtraModel> extras;

  OrderDetailModel({
    required this.fnbId,
    required this.fnbName,
    this.fnbImage,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.level,
    required this.extras,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    // Get name from fnb_name (full show response) OR fnb.name (simplified kitchen response)
    String name = json['fnb_name'] ?? "";
    if (name.isEmpty && json['fnb'] != null && json['fnb'] is Map) {
      name = json['fnb']['name'] ?? "";
    }

    return OrderDetailModel(
      fnbId: json['fnb_id'] ?? 0,
      fnbName: name,
      fnbImage: json['fnb_image'] ?? (json['fnb'] != null && json['fnb'] is Map ? json['fnb']['image'] : null),
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      totalPrice: double.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0,
      level: json['level'] != null ? (json['level'] as List).map((e) => OrderLevelModel.fromJson(e as Map<String, dynamic>)).toList() : [],
      extras: json['extras'] != null ? (json['extras'] as List).map((e) => OrderExtraModel.fromJson(e as Map<String, dynamic>)).toList() : [],
    );
  }
}

class OrderLevelModel {
  final int id;
  final String name;
  final double price;

  OrderLevelModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory OrderLevelModel.fromJson(Map<String, dynamic> json) {
    return OrderLevelModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
    );
  }
}

class OrderExtraModel {
  final int id;
  final String name;
  final double price;

  OrderExtraModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory OrderExtraModel.fromJson(Map<String, dynamic> json) {
    return OrderExtraModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
    );
  }
}
