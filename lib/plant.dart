import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id;
  final String name;
  final String category;
  final DateTime date;

  Plant(
      {this.id = '',
      required this.name,
      required this.category,
      required this.date});

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'category': category, 'date': date};

  static Plant fromJson(Map<String, dynamic> json) => Plant(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        date: (json['date'] as Timestamp).toDate(),
      );
}
