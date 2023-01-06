import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seeds/models/plant.dart';

class EditPlantPage extends StatefulWidget {
  const EditPlantPage({super.key});

  static const routeName = '/extractArguments';

  @override
  State<EditPlantPage> createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    final currentPlant = ModalRoute.of(context)!.settings.arguments as Plant;
    final controllerName = TextEditingController(text: currentPlant.name);
    final controllerCategorie =
        TextEditingController(text: currentPlant.category);
    final controllerDate =
        TextEditingController(text: format.format(currentPlant.date));

    return Scaffold(
      appBar: AppBar(
        title: Text(currentPlant.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: decoration("Nom du légume"),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerCategorie,
            decoration: decoration("Sa catégorie"),
          ),
          const SizedBox(height: 24),
          DateTimeField(
            controller: controllerDate,
            decoration: decoration('Période de sémis'),
            format: format,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentPlant.date,
                  lastDate: DateTime(2100));
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            label: const Text('Mettre à jour'),
            onPressed: () {
              final editingPlant = currentPlant.copyWith(
                name: controllerName.text,
                category: controllerCategorie.text,
                date: DateTime.parse(controllerDate.text),
              );
              updatePlant(editingPlant, currentPlant);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.update),
          ),
          ElevatedButton.icon(
            label: const Text('Supprimer'),
            onPressed: () {
              deletePlant(id: currentPlant.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  Future deletePlant({
    required String id,
  }) async {
    FirebaseFirestore.instance.collection('plants').doc(id).delete();
  }

  Future updatePlant(Plant updatingPlant, Plant currentPlant) async {
    final docPlant =
        FirebaseFirestore.instance.collection('plants').doc(currentPlant.id);
    await docPlant.update(updatingPlant.toJson()).then(
        (value) => log("Success update"),
        onError: (e) => log("Error update"));
  }
}
