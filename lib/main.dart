import 'package:seeds/screens/categories_page.dart';
import 'package:seeds/screens/leaf_plant_page.dart';
import 'package:seeds/screens/plant_page.dart';
import 'package:seeds/screens/views/edit_plant_page.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      routes: {
        EditPlantPage.routeName: (context) => const EditPlantPage(),
        '/second': (context) => const FeuillePlantPage(),
      },
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
  final PageController _pageController = PageController(initialPage: 0);
  final controller = TextEditingController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          controller: _pageController,
          children: const <Widget>[PlantPage(), CategoriesPlant()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(_currentIndex);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Acceuil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_repair_service),
              label: 'Boite',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.forest),
            //   label: 'Culture',
            // ),
          ],
          selectedItemColor: Colors.amber[800],
        ),
      );
}
