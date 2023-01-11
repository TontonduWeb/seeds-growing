import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/plant.dart';
import 'package:seeds/pages/views/add_plant_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _PlantsRefPageState();
}

final user = FirebaseAuth.instance.currentUser!;

class _PlantsRefPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();
  var plants = <Plant>[];
  final plantsFromFirestore = <Plant>[];
  final userPlants = <Plant>[];

  Stream<List<Plant>> readUserPlantsFS() => FirebaseFirestore.instance
      .collection('plants')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map(
            (doc) => Plant.fromJson(
              {
                ...doc.data(),
                'id': doc.id,
              },
            ),
          )
          .toList());

  Stream<List<Plant>> readPlantsFS() => FirebaseFirestore.instance
      .collection('plantsRef')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Plant.fromJson(doc.data())).toList());

  @override
  void initState() {
    listenUserPlants();
    listenPlants();
    plants.addAll(plantsFromFirestore);
    super.initState();
  }

  void listenPlants() {
    readPlantsFS().listen((listPlant) {
      for (var plant in listPlant) {
        plantsFromFirestore.add(plant);
        plantsFromFirestore.sort((a, b) => a.nom.compareTo(b.nom));
      }
    });
  }

  void listenUserPlants() {
    readUserPlantsFS().listen((listPlant) {
      for (var userPlant in listPlant) {
        userPlants.add(userPlant);
        userPlants.sort((a, b) => a.nom.compareTo(b.nom));
      }
    });
  }

  void filterSearchResults(String searchInput) {
    if (searchInput.isNotEmpty) {
      List<Plant> inputPlantList = <Plant>[];
      for (var plantFS in plantsFromFirestore) {
        if (plantFS.nom.contains(searchInput)) {
          inputPlantList.add(plantFS);
          for (var userPlant in userPlants) {
            if (plantFS.nom == userPlant.nom) {
              inputPlantList.remove(plantFS);
            }
          }
        }
      }
      setState(() {
        plants.clear();
        plants.addAll(inputPlantList);
      });
      return;
    } else {
      setState(() {
        plants.clear();
        plants.addAll(plantsFromFirestore);
      });
    }
  }

  void selectPlant(Plant plantRef) {
    Navigator.pushNamed(context, AddPlantPage.routeName,
        arguments: Plant(
            id: plantRef.id,
            userId: user.uid,
            nom: plantRef.nom,
            category: plantRef.category,
            dureeDeGerminationFromRef: plantRef.dureeDeGerminationFromRef));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionnez vos graines'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Quels légumes voulez-vous cultiver ?",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: plants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(plants[index].nom),
                  subtitle: Text(plants[index].category),
                  onTap: () => selectPlant(plants[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
