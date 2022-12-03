import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:seeds/plant.dart';
import 'package:seeds/plant_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Seeds Growing App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Stream<List<Plant>> readPlants() => FirebaseFirestore.instance
      .collection('plants')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Plant.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: TextField(controller: controller),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final name = controller.text;
                final categorie = controller.text;
                final date = DateTime.parse(controller.text);
                createPlant(name: name, categorie: categorie, date: date);
              },
            )
          ],
        ),
        body: StreamBuilder<List<Plant>>(
          stream: readPlants(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final plants = snapshot.data!;
              return ListView(
                children: plants.map(buildPlant).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlantPage(),
                ));
          },
        ),
      );
  Future createPlant(
      {required String name,
      required String categorie,
      required DateTime date}) async {
    final docPlant = FirebaseFirestore.instance.collection('plants').doc();

    final plant =
        Plant(id: docPlant.id, name: name, categorie: categorie, date: date);
    final json = plant.toJson();

    await docPlant.set(json);
  }
}

Widget buildPlant(Plant plant) => ListTile(
      title: Text(plant.name),
      subtitle: Text(plant.categorie),
      trailing: Text('${plant.date}'),
      isThreeLine: true,
    );
