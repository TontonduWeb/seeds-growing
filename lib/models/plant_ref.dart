class PlantRef {
  final String id;
  final String userId;
  final String nom;
  final String category;
  final String dureeDeGerminationFromRef;

  PlantRef(
      {required this.id,
      required this.nom,
      required this.category,
      required this.userId,
      required this.dureeDeGerminationFromRef});

  static PlantRef fromJson(Map<String, dynamic> json) => PlantRef(
        id: json['id'],
        nom: json['nom'],
        category: json['Type'],
        userId: json['userId'],
        dureeDeGerminationFromRef: json['Durée de germination'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'Type': category,
        'userId': userId,
        'Durée de germination': dureeDeGerminationFromRef,
      };
}
