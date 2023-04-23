import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:seeds/pages/auth_page.dart';
import 'package:seeds/pages/verify_email_page.dart';
import 'package:seeds/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
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
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromRGBO(29, 60, 69, 1.0),
            secondary: const Color.fromRGBO(210, 96, 26, 1.0),
            background: const Color.fromRGBO(255, 241, 225, 1.0),
          ),
          fontFamily: 'Rubik',
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
        home: const AuthStatePage(),
      );
}

class AuthStatePage extends StatefulWidget {
  const AuthStatePage({super.key});

  @override
  State<AuthStatePage> createState() => _AuthStatePageState();
}

class _AuthStatePageState extends State<AuthStatePage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      );
}
