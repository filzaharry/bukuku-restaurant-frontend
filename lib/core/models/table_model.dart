class TableModel {
  final int id;
  final String uniqueId;
  final String name;
  final String status;

  TableModel({
    required this.id,
    required this.uniqueId,
    required this.name,
    required this.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] ?? 0,
      uniqueId: json['unique_id'] ?? "",
      name: json['name'] ?? "",
      status: json['status'] ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TableModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
