import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/pages/views/add_plant_page.dart';
import 'package:seeds/pages/views/edit_plant_page.dart';

import '../models/plant.dart';

class FruitPlantPage extends StatefulWidget {
  const FruitPlantPage({super.key});

  @override
  State<FruitPlantPage> createState() => _FruitPlantPage();
}

class _FruitPlantPage extends State<FruitPlantPage> {
  Stream<List<Plant>> getRootPlants() => FirebaseFirestore.instance
      .collection('plants')
      .where("category", isEqualTo: "fruit")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Plant.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Plantes Fruit'),
        ),
        body: StreamBuilder<List<Plant>>(
          stream: getRootPlants(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final plants = snapshot.data!;
              return ListView(
                children: plants.map((plant) => buildPlant(plant)).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPlantPage(),
                ));
          },
        ),
      );

  Widget buildPlant(Plant plant) => ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            EditPlantPage.routeName,
            arguments: plant,
          );
        },
        title: Text(plant.name),
        subtitle: Text(plant.category),
      );
}
