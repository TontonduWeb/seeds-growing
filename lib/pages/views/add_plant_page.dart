import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeds/models/plant.dart';

// final plantAddedProvider = StateProvider((_) => false);

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  static const routeName = '/addPlant';

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    final currentPlant = ModalRoute.of(context)!.settings.arguments as Plant;
    final dureeDeGerminationController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPlant.nom),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ListTile(
            title: const Text('Ajuste la durée de germination'),
            subtitle: Text(
                'Durée de germination suggéré: ${currentPlant.dureeDeGerminationFromRef}'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: dureeDeGerminationController,
            decoration: decoration("Durée de germination"),
          ),
          const SizedBox(height: 24),
          // DateTimeField(
          //   controller: controllerDate,
          //   decoration: decoration('Période de sémis'),
          //   format: format,
          //   onShowPicker: (context, currentValue) {
          //     return showDatePicker(
          //         context: context,
          //         firstDate: DateTime(1900),
          //         initialDate: currentPlant.date,
          //         lastDate: DateTime(2100));
          //   },
          // ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            label: const Text('Ajouter la plante'),
            onPressed: () {
              final settingPlant = Plant(
                id: currentPlant.id,
                nom: currentPlant.nom,
                userId: currentPlant.userId,
                category: currentPlant.category,
                dureeDeGermination:
                    int.parse(dureeDeGerminationController.text),
                dureeDeGerminationFromRef:
                    currentPlant.dureeDeGerminationFromRef,
                // date: DateTime.parse(dateController.text),
              );
              setPlant(settingPlant: settingPlant);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  Future setPlant({required Plant settingPlant}) async {
    final docPlant = FirebaseFirestore.instance.collection('plants').doc();
    await docPlant
        .set(settingPlant.toJson())
        .then((value) => log("Success set"), onError: (e) => log("Error set"));
  }
}
