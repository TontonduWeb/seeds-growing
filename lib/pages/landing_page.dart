import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seeds/pages/auth_page.dart';
import 'package:seeds/pages/menu_page.dart';
import 'package:seeds/pages/views/add_plant_page.dart';
import 'package:seeds/pages/views/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/onBoarding_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final controller = TextEditingController();
  bool isUserConnected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Seeds Growing App',
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
        routes: {
          AddPlantPage.routeName: (context) => const AddPlantPage(),
          '/second': (context) => const SearchPage(),
        },
        home: isUserConnected ? const AuthPage() : const MenuPage());
  }
}
