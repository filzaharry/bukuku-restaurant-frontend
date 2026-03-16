class PaginationMeta {
  final int currentPage;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;

  PaginationMeta({
    required this.currentPage,
    this.from = 0,
    required this.lastPage,
    required this.perPage,
    this.to = 0,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? json['page'] ?? 1,
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? json['totalPage'] ?? 1,
      perPage: json['per_page'] ?? json['totalPerPage'] ?? 10,
      to: json['to'] ?? 0,
      total: json['total'] ?? json['totalData'] ?? 0,
    );
  }
}
