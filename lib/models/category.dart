class Category {
  final String id;
  final String name;

  Category({this.id = '', required this.name});

  static Category fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
      );
}
