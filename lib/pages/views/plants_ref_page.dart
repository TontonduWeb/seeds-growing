import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/plantsRef.dart';

class PlantsRefPage extends StatefulWidget {
  const PlantsRefPage({super.key});

  @override
  State<PlantsRefPage> createState() => _PlantsRefPageState();
}

class _PlantsRefPageState extends State<PlantsRefPage> {
  TextEditingController editingController = TextEditingController();
  var plants = <PlantRef>[];
  final plantsFromFirestore = <PlantRef>[];

  Stream<List<PlantRef>> readPlants() => FirebaseFirestore.instance
      .collection('plantsRef')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => PlantRef.fromJson(doc.data())).toList());

  @override
  void initState() {
    listenPlants();
    plants.addAll(plantsFromFirestore);
    super.initState();
  }

  void listenPlants() {
    readPlants().listen((event) {
      for (var element in event) {
        plantsFromFirestore.add(element);
        plantsFromFirestore.sort((a, b) => a.nom.compareTo(b.nom));
      }
    });
  }

  void filterSearchResults(String query) {
    List<PlantRef> dummySearchList = <PlantRef>[];
    dummySearchList.addAll(plantsFromFirestore);
    if (query.isNotEmpty) {
      List<PlantRef> dummyListData = <PlantRef>[];
      for (var item in dummySearchList) {
        if (item.nom.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        plants.clear();
        plants.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        plants.clear();
        plants.addAll(plantsFromFirestore);
      });
    }
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
