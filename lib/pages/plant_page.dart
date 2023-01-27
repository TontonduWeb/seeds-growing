import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeds/models/plant.dart';
import 'package:seeds/pages/profile_page.dart';
import 'package:seeds/pages/views/edit_plant_page.dart';
import 'auth_page.dart';

// final helloWorldProvider = Provider((_) => 'Hello world');

// class PlantPage extends ConsumerWidget {
//   const PlantPage({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final String value = ref.watch(helloWorldProvider);

//     return MaterialApp(
//         home: Scaffold(
//       appBar: AppBar(
//         title: const Text('Test'),
//       ),
//       body: Center(
//         child: Text(value),
//       ),
//     ));
//   }
// }

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  bool isUserConnected = false;
  final user = FirebaseAuth.instance.currentUser!;

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
            title: const Text('Toutes vos graines répertoriées'),
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
                plants.sort((a, b) => a.nom.compareTo(b.nom));
                return ListView(
                  children: plants.map((plant) => buildPlant(plant)).toList(),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );

  Widget buildPlant(Plant plant) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPlantPage(currentPlant: plant)));
      },
      title: Text(plant.nom),
      subtitle: Text(plant.category),
      // leading: Text(DateTime.fromMillisecondsSinceEpoch(plant.date).toString()),
    );
  }
}
