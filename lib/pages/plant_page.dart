import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/plant.dart';
import 'package:seeds/pages/profile_page.dart';
import 'package:seeds/pages/views/add_plant_page.dart';
import 'package:seeds/pages/views/edit_plant_page.dart';

import 'auth_page.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  bool isUserConnected = false;
  final user = FirebaseAuth.instance.currentUser!;

  // void getUser() {
  //   if (FirebaseAuth.instance.currentUser != null) isUserConnected = true;
  // }

  Stream<List<Plant>> readPlants() => FirebaseFirestore.instance
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

  @override
  Widget build(BuildContext context) => isUserConnected
      ? const AuthPage()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Toutes vos plantes répertoriées'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.account_circle),
                tooltip: 'Profile',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ));
                },
              ),
            ],
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

  Widget buildPlant(Plant plant) {
    final user = FirebaseAuth.instance.currentUser!;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, EditPlantPage.routeName,
            arguments: Plant(
                id: plant.id,
                userId: user.uid,
                name: plant.name,
                category: plant.category,
                date: plant.date));
      },
      title: Text(plant.name),
      subtitle: Text(plant.category),
    );
  }
}
