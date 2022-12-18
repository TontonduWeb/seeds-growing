import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/screens/views/add_plant_page.dart';
import 'package:seeds/screens/views/edit_plant_page.dart';

import '../plant.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  Stream<List<Plant>> readPlants() => FirebaseFirestore.instance
      .collection('plants')
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Toutes vos plantes répertoriées'),
        ),
        body: StreamBuilder<List<Plant>>(
          stream: readPlants(),
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
          Navigator.pushNamed(context, EditPlantPage.routeName,
              arguments: Plant(
                  id: plant.id,
                  name: plant.name,
                  categorie: plant.categorie,
                  date: plant.date));
        },
        title: Text(plant.name),
        subtitle: Text(plant.categorie),
      );
}
