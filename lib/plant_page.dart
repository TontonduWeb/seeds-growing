import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:seeds/plant.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  final format = DateFormat("yyyy-MM-dd");
  final controllerName = TextEditingController();
  final controllerCategorie = TextEditingController();
  final controllerDate = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Ajouter une plante'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: decoration('Nom'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerCategorie,
              decoration: decoration('Categorie'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            DateTimeField(
              controller: controllerDate,
              format: format,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
                child: const Text('Créer'),
                onPressed: () {
                  final plant = Plant(
                      name: controllerName.text,
                      categorie: controllerCategorie.text,
                      date: DateTime.parse(controllerDate.text));
                  createPlant(plant);
                  Navigator.pop(context);
                })
          ],
        ),
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  Future createPlant(Plant plant) async {
    final docPlant = FirebaseFirestore.instance.collection('plants').doc();
    plant.id = docPlant.id;
    final json = plant.toJson();
    await docPlant.set(json);
  }
}
