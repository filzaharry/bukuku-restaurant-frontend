class MenuModel {
  final String name;
  final String url;
  final String? icon;
  final List<MenuModel> child;

  MenuModel({
    required this.name,
    required this.url,
    this.icon,
    this.child = const [],
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      icon: json['icon'],
      child: json['child'] != null
          ? List<MenuModel>.from(json['child'].map((x) => MenuModel.fromJson(x)))
          : [],
    );
  }
}
