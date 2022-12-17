import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id;
  final String name;
  final String categorie;
  final DateTime date;

  Plant(
      {this.id = '',
      required this.name,
      required this.categorie,
      required this.date});

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'categorie': categorie, 'date': date};

  static Plant fromJson(Map<String, dynamic> json) => Plant(
        id: json['id'],
        name: json['name'],
        categorie: json['categorie'],
        date: (json['date'] as Timestamp).toDate(),
      );
}
