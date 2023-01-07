import 'package:cloud_firestore/cloud_firestore.dart';

class PlantRef {
  final String nom;

  PlantRef({required this.nom});

  static PlantRef fromJson(Map<String, dynamic> json) => PlantRef(
        nom: json['nom'],
      );
}
