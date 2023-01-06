import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/category.dart';
import 'package:seeds/models/plant.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key, this.category});

  final String? category;

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  var _dropdownValue = 'feuille';
  final format = DateFormat("yyyy-MM-dd");
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final plantCategories = [];

  Stream<List<Category>> readCategories() => FirebaseFirestore.instance
      .collection('categories')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map(
            (doc) => Category.fromJson(
              {
                ...doc.data(),
                'id': doc.id,
              },
            ),
          )
          .toList());

  @override
  void initState() {
    readCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une plante'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: decoration('Nom'),
          ),
          const SizedBox(height: 24),
          StreamBuilder<List<Category>>(
              stream: readCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final categories = snapshot.data!;
                  return DropdownButton<String>(
                    value: _dropdownValue,
                    onChanged: dropdownCallBack,
                    items: categories.map<DropdownMenuItem<String>>((category) {
                      return DropdownMenuItem<String>(
                          value: category.name, child: Text(category.name));
                    }).toList(),
                  );
                }
                return const SizedBox(height: 24);
              }),
          const SizedBox(height: 24),
          DateTimeField(
            controller: dateController,
            decoration: decoration('Période de semis'),
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
          ElevatedButton.icon(
            label: const Text('Créer'),
            onPressed: () {
              final plant = Plant(
                  userId: user.uid,
                  name: nameController.text,
                  category: _dropdownValue,
                  date: DateTime.parse(dateController.text));
              createPlant(plant);
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

  Future createPlant(Plant plant) async {
    final docPlant = FirebaseFirestore.instance.collection('plants').doc();
    final json = plant.toJson();
    await docPlant.set(json);
  }

  dropdownCallBack(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }
}
