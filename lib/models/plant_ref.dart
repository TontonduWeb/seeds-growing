class PlantRef {
  final String id;
  final String userId;
  final String nom;
  final String category;
  final String dureeDeGerminationFromRef;
  final String? idSemisExterieur;
  final String? idSemisInterieur;
  final String? idPlantation;

  PlantRef(
      {required this.id,
      required this.nom,
      required this.category,
      required this.userId,
      required this.dureeDeGerminationFromRef,
      required this.idSemisExterieur,
      required this.idSemisInterieur,
      required this.idPlantation});

  static PlantRef fromJson(Map<String, dynamic> json) => PlantRef(
      id: json['id'],
      nom: json['nom'],
      category: json['Type'],
      userId: json['userId'],
      dureeDeGerminationFromRef: json['Durée de germination'],
      idSemisExterieur: json['id_semis_exterieur'],
      idSemisInterieur: json['id_semis_interieur'],
      idPlantation: json['id_plantation_ref']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'Type': category,
        'userId': userId,
        'Durée de germination': dureeDeGerminationFromRef,
        'id_semis_exterieur': idSemisExterieur,
        'id_semis_interieur': idSemisInterieur,
        'id_plantation_ref': idPlantation,
      };
}
