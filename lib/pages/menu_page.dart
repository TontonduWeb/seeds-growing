import 'package:flutter/material.dart';
import 'package:seeds/pages/calendar_page.dart';
import 'package:seeds/pages/categories_page.dart';
import 'package:seeds/pages/plant_page.dart';
import 'package:seeds/pages/search_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    PlantPage(),
    SearchPage(),
    CalendarPage(),
    CategoriesPlant(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _pages.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Acceuil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Recherche',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendrier',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_repair_service),
              label: 'Boite',
            ),
          ],
          selectedItemColor: Colors.amber[800],
        ),
      );
}
