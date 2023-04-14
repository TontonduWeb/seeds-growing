import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seeds/pages/auth_page.dart';
import 'package:seeds/pages/categories_page.dart';
import 'package:seeds/pages/plant_page.dart';
import 'package:seeds/pages/views/add_plant_page.dart';
import 'package:seeds/pages/views/search_page.dart';
import 'calendar_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        Locale('zh'),
        Locale('ar'),
        Locale('ja'),
      ],
      locale: const Locale('fr'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(29, 60, 69, 1.0),
          secondary: const Color.fromRGBO(210, 96, 26, 1.0),
          background: const Color.fromRGBO(255, 241, 225, 1.0),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(255, 241, 225, 1.0),
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(29, 60, 69, 1.0),
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(255, 241, 225, 1.0), fontSize: 20),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(255, 241, 225, 1.0),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromRGBO(29, 60, 69, 1.0),
          unselectedItemColor: Color.fromRGBO(255, 241, 225, 1.0),
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Color.fromRGBO(29, 60, 69, 1.0),
          ),
          bodySmall: TextStyle(
            color: Color.fromRGBO(210, 96, 26, 1.0),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color.fromRGBO(210, 96, 26, 1.0),
          // textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(29, 60, 69, 1.0),
            textStyle: const TextStyle(
              color: Color.fromRGBO(255, 241, 225, 1.0),
            ),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Seeds Growing App'),
      routes: {
        AddPlantPage.routeName: (context) => const AddPlantPage(),
        '/second': (context) => const SearchPage(),
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
  bool isUserConnected = false;
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
  Widget build(BuildContext context) => isUserConnected
      ? const AuthPage()
      : Scaffold(
          body: PageView(
            controller: _pageController,
            children: const <Widget>[
              PlantPage(),
              CategoriesPlant(),
              SearchPage(),
              CalendarPage(),
            ],
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
