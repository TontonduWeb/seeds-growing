import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/models/plant.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:intl/intl.dart';

class EditPlantPage extends StatefulWidget {
  final Plant currentPlant;
  const EditPlantPage({Key? key, required this.currentPlant}) : super(key: key);

  @override
  State<EditPlantPage> createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  // final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    final dureeDeGerminationController = TextEditingController(
        text: widget.currentPlant.dureeDeGermination.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentPlant.nom),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ListTile(
            title: const Text('Ajuste la durée de germination'),
            subtitle: Text(
                'Durée de germination suggéré: ${widget.currentPlant.dureeDeGerminationFromRef}'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: dureeDeGerminationController,
            decoration: decoration("Durée de germination en nombre de jours"),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            label: const Text('Mettre à jour'),
            onPressed: () {
              final editingPlant = Plant(
                id: widget.currentPlant.id,
                nom: widget.currentPlant.nom,
                userId: widget.currentPlant.userId,
                category: widget.currentPlant.category,
                dureeDeGermination:
                    int.parse(dureeDeGerminationController.text),
                dureeDeGerminationFromRef:
                    widget.currentPlant.dureeDeGerminationFromRef,
                isSeedlingUnderGreenhouse:
                    widget.currentPlant.isSeedlingUnderGreenhouse,
                // date: DateTime.parse(dateController.text),
              );
              updatePlant(editingPlant, widget.currentPlant);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.update),
          ),
          ElevatedButton.icon(
            label: const Text('Supprimer'),
            icon: const Icon(Icons.delete),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(210, 96, 26, 1.0)),
            onPressed: () {
              deletePlant(id: widget.currentPlant.id);
              Navigator.pop(context);
            },
          ),
          ElevatedButton.icon(
            label: const Text(
              'Lancer la germination',
              style: TextStyle(color: Color.fromRGBO(29, 60, 69, 1.0)),
            ),
            icon:
                const Icon(Icons.start, color: Color.fromRGBO(29, 60, 69, 1.0)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 241, 225, 1.0),
            ),
            onPressed: () {
              final isSeedlingUnderGreenhouse = Plant(
                id: widget.currentPlant.id,
                nom: widget.currentPlant.nom,
                userId: widget.currentPlant.userId,
                category: widget.currentPlant.category,
                dureeDeGermination:
                    int.parse(dureeDeGerminationController.text),
                dureeDeGerminationFromRef:
                    widget.currentPlant.dureeDeGerminationFromRef,
                // date: DateTime.parse(dateController.text),
                isSeedlingUnderGreenhouse: true,
                startSeedlingUnderGreenHouse: DateTime.now(),
              );
              updateStartSeedlingUnderGreenHouse(isSeedlingUnderGreenhouse);
              Navigator.pop(context);
            },
          ),
          ElevatedButton.icon(
            label: const Text(
              'Arrêter la germination',
              style: TextStyle(color: Color.fromRGBO(210, 96, 26, 1.0)),
            ),
            icon: const Icon(
              Icons.stop,
              color: Color.fromRGBO(210, 96, 26, 1.0),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 241, 225, 1.0),
            ),
            onPressed: () {
              final isSeedlingUnderGreenhouse = Plant(
                id: widget.currentPlant.id,
                nom: widget.currentPlant.nom,
                userId: widget.currentPlant.userId,
                category: widget.currentPlant.category,
                dureeDeGermination:
                    int.parse(dureeDeGerminationController.text),
                dureeDeGerminationFromRef:
                    widget.currentPlant.dureeDeGerminationFromRef,
                // date: DateTime.parse(dateController.text),
                isSeedlingUnderGreenhouse: false,
              );
              updateStopSeedlingUnderGreenHouse(isSeedlingUnderGreenhouse);
              Navigator.pop(context);
            },
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
    FirebaseFirestore.instance.collection('userPlante').doc(id).delete();
  }

  Future updateStartSeedlingUnderGreenHouse(
      Plant startSeedlingUnderGreenHouse) async {
    final docPlant = FirebaseFirestore.instance
        .collection('userPlante')
        .doc(widget.currentPlant.id);
    await docPlant.update(startSeedlingUnderGreenHouse.toJson()).then(
        (value) => log("Success startSeedlingUnderGreenHouse"),
        onError: (e) => log("Error startSeedlingUnderGreenHouse"));
  }

  Future updateStopSeedlingUnderGreenHouse(
      Plant stopSeedlingUnderGreenHouse) async {
    final docPlant = FirebaseFirestore.instance
        .collection('userPlante')
        .doc(widget.currentPlant.id);
    await docPlant.update(stopSeedlingUnderGreenHouse.toJson()).then(
        (value) => log("Success stopSeedlingUnderGreenHouse"),
        onError: (e) => log("Error stopSeedlingUnderGreenHouse"));
  }

  Future updatePlant(Plant editingPlant, Plant currentPlant) async {
    final docPlant = FirebaseFirestore.instance
        .collection('userPlante')
        .doc(widget.currentPlant.id);
    await docPlant.update(editingPlant.toJson()).then(
        (value) => log("Success update"),
        onError: (e) => log("Error update"));
  }
}
