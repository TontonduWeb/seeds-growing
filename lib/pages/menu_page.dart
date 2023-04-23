import 'package:flutter/material.dart';
import 'package:seeds/pages/calendar_page.dart';
import 'package:seeds/pages/categories_page.dart';
import 'package:seeds/pages/plant_page.dart';
import 'package:seeds/pages/views/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/onBoarding_widget.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool newLaunch = true;

  @override
  void initState() {
    super.initState();
    loadNewLaunch();
    print('newLaunchInit : $newLaunch');

    _pageController.addListener(() {
      if (_pageController.page!.round() != _currentIndex) {
        setState(() {
          _currentIndex = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  loadNewLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bool _newLaunch = ((prefs.getBool('newLaunch') ?? true));
      newLaunch = _newLaunch;
    });
    print('newLaunchFunction: $newLaunch');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body:
            //  newLaunch
            //     ? const OnBoardingPage()
            // :
            Stack(children: <Widget>[
          PageView(
            controller: _pageController,
            children: const <Widget>[
              PlantPage(),
              CategoriesPlant(),
              SearchPage(),
              CalendarPage(),
            ],
          ),
        ]),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Recherche',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendrier',
            ),
          ],
          selectedItemColor: Colors.amber[800],
        ),
      );
}
