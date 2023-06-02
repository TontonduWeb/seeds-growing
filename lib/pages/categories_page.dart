import 'package:flutter/material.dart';
import 'package:seeds/pages/plant_category_page.dart';

class CategoriesPlant extends StatelessWidget {
  const CategoriesPlant({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('La boite à graines'),
      ),
      body: Center(
        child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: <Widget>[
              ElevatedButton.icon(
                label: const Text('feuille'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlantCategoryPage(
                          category: 'légume feuille',
                        ),
                      ));
                },
                icon: const Icon(Icons.eco),
              ),
              ElevatedButton.icon(
                label: const Text("fruit"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlantCategoryPage(
                          category: 'légume fruit',
                        ),
                      ));
                },
                icon: const Icon(Icons.trip_origin),
              ),
              ElevatedButton.icon(
                label: const Text("fleur"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlantCategoryPage(
                          category: 'légume fleur',
                        ),
                      ));
                },
                icon: const Icon(Icons.local_florist),
              ),
              ElevatedButton.icon(
                label: const Text("racine"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlantCategoryPage(
                          category: 'légume racine',
                        ),
                      ));
                },
                icon: const Icon(Icons.grass),
              ),
            ]),
      ));
}
