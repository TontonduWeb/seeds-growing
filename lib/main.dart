import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    const ProviderScope(child: MyApp()),
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
        // theme: ThemeData(
        //     colorScheme: ColorScheme.fromSwatch().copyWith(
        //       primary: const Color.fromRGBO(30, 30, 30, 1.0),
        //       secondary: const Color.fromRGBO(210, 96, 26, 1.0),
        //       background: const Color.fromRGBO(255, 241, 225, 1.0),
        //     ),
        //     scaffoldBackgroundColor: const Color.fromRGBO(255, 241, 225, 1.0),
        //     appBarTheme:
        //         const AppBarTheme(color: Color.fromRGBO(255, 241, 225, 1.0))),
        home: const MyHomePage(title: 'Seeds Growing App'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
