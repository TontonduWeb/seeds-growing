import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id;
  final String userId;
  late final String nom;
  final String category;
  final int? dureeDeGermination;
  final String dureeDeGerminationFromRef;
  final bool? isSeedlingUnderGreenhouse;
  final DateTime? startSeedlingUnderGreenHouse;

  // final DateTime date;

  Plant({
    this.id = '',
    required this.userId,
    required this.nom,
    required this.category,
    this.dureeDeGermination,
    required this.dureeDeGerminationFromRef,
    this.isSeedlingUnderGreenhouse = false,
    this.startSeedlingUnderGreenHouse,
    // required this.date
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'nom': nom,
        'Type': category,
        'Durée de germination user': dureeDeGermination,
        'Durée de germination': dureeDeGerminationFromRef,
        'La graine est planté sous serre': isSeedlingUnderGreenhouse,
        'date de démarrage de la germination sous serre':
            startSeedlingUnderGreenHouse,
        // 'date': date
      };

  static Plant fromJson(Map<String, dynamic> json) => Plant(
        id: json['id'],
        userId: json['userId'],
        nom: json['nom'],
        category: json['Type'],
        dureeDeGermination: json['Durée de germination user'],
        dureeDeGerminationFromRef: json['Durée de germination'],
        isSeedlingUnderGreenhouse: json['La graine est planté sous serre'],
        startSeedlingUnderGreenHouse:
            (json['date de démarrage de la germination sous serre']
                    as Timestamp?)
                ?.toDate(),
      );

  Plant copyWith({
    String? id,
    String? nom,
    String? userId,
    String? category,
    int? dureeDeGermination,
    String? dureeDeGerminationFromRef,
    bool? isSeedlingUnderGreenhouse,
    DateTime? startSeedlingUnderGreenHouse,
    DateTime? date,
  }) =>
      Plant(
        id: id ?? this.id,
        nom: this.nom,
        userId: this.userId,
        category: this.category,
        dureeDeGermination: this.dureeDeGermination,
        dureeDeGerminationFromRef: this.dureeDeGerminationFromRef,
        isSeedlingUnderGreenhouse: this.isSeedlingUnderGreenhouse,
        startSeedlingUnderGreenHouse:
            startSeedlingUnderGreenHouse ?? this.startSeedlingUnderGreenHouse,
        // date: date ?? this.date,
      );
}
