import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id;
  final String userId;
  final String name;
  final String category;
  final DateTime date;

  Plant(
      {this.id = '',
      required this.userId,
      required this.name,
      required this.category,
      required this.date});

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'category': category,
        'date': date
      };

  static Plant fromJson(Map<String, dynamic> json) => Plant(
        id: json['id'],
        userId: json['userId'],
        name: json['name'],
        category: json['category'],
        date: (json['date'] as Timestamp).toDate(),
      );

  Plant copyWith({String? name, String? category, DateTime? date}) => Plant(
        userId: userId,
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        date: date ?? this.date,
      );
}
