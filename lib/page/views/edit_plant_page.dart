import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seeds/plant.dart';

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
    final args = ModalRoute.of(context)!.settings.arguments as Plant;
    final controllerName = TextEditingController(text: args.name);
    final controllerCategorie = TextEditingController(text: args.category);
    final controllerDate =
        TextEditingController(text: format.format(args.date));
    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
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
                  initialDate: args.date,
                  lastDate: DateTime(2100));
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            label: const Text('Mettre à jour'),
            onPressed: () {
              final plant = Plant(
                  name: controllerName.text,
                  category: controllerCategorie.text,
                  date: DateTime.parse(controllerDate.text));
              updatePlant(plant, args);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.update),
          ),
          ElevatedButton.icon(
            label: const Text('Supprimer'),
            onPressed: () {
              deletePlant(id: args.id);
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

  Future updatePlant(Plant plant, args) async {
    Map<String, dynamic> data = <String, dynamic>{
      "name": plant.name,
      "category": plant.category,
      "date": plant.date
    };
    final docPlant =
        FirebaseFirestore.instance.collection('plants').doc(args.id);
    // final json = plant.toJson();
    await docPlant.update(data).then((value) => log("Success update"),
        onError: (e) => log("Error update"));
  }
}
