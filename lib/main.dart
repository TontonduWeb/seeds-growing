import 'package:firebase_auth/firebase_auth.dart';
import 'package:seeds/page/auth_page.dart';
import 'package:seeds/page/leaf_plant_page.dart';
import 'package:seeds/page/verify_email_page.dart';
import 'package:seeds/page/views/edit_plant_page.dart';
import 'package:seeds/utils.dart';

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

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  final controller = TextEditingController();

  // int _currentIndex = 0;

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
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.hasData) {
              return const VerifyEmailPage();
            }
            return const AuthPage();
          },
        ),
        // PageView(
        //   onPageChanged: (index) {
        //     setState(() => _currentIndex = index);
        //   },
        //   controller: _pageController,
        //   children: const <Widget>[PlantPage(), CategoriesPlant()],
        // ),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: _currentIndex,
        //   onTap: (index) {
        //     setState(() => _currentIndex = index);
        //     _pageController.jumpToPage(_currentIndex);
        //   },
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Acceuil',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home_repair_service),
        //       label: 'Boite',
        //     ),
        //     // BottomNavigationBarItem(
        //     //   icon: Icon(Icons.forest),
        //     //   label: 'Culture',
        //     // ),
        //   ],
        //   selectedItemColor: Colors.amber[800],
        // ),
      );
}
