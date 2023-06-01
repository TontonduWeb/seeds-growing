import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:seeds/models/plant.dart';
import 'package:seeds/pages/profile_page.dart';
import 'package:seeds/pages/search_page.dart';
import 'package:seeds/pages/views/edit_plant_page.dart';

import '../models/userToken.dart';
import '../widgets/notification_badge_widget.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  bool isUserConnected = false;
  final user = FirebaseAuth.instance.currentUser!;
  late int _totalNotifications;
  PushNotification? _notificationInfo;
  late final FirebaseMessaging _messaging;

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  @override
  void initState() {
    super.initState();
    checkForInitialMessage();
    _totalNotifications = 2;

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp has been clicked!');
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    registerNotification();
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    _messaging.getToken().then((token) {
      final user = FirebaseAuth.instance.currentUser!;
      final userToken = UserToken(
        token: token!,
        email: user.email!,
        uid: user.uid,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userToken.toJson())
          .then((value) => log("User Token Added"),
              onError: (error) => log("Failed to add user token: $error"));

      print('Token: $token');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    _messaging.subscribeToTopic("messaging");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _totalNotifications = 0;
      _notificationInfo = PushNotification(
        title: 'Welcome to Seeds',
        body: 'You will now receive notifications',
      );

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.notification!.body}');
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification!.body}');
        }
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        if (mounted) {
          setState(() {
            _notificationInfo = notification;
            _totalNotifications++;
          });
        }
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: const Duration(seconds: 2),
          );
        } else {
          print('User declined or has not accepted permission');
        }
      });
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  Stream<List<Plant>> readPlants() => FirebaseFirestore.instance
      .collection('userPlante')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map(
            (doc) => Plant.fromJson(
              {
                ...doc.data(),
                'id': doc.id,
              },
            ),
          )
          .toList());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Toutes vos graines répertoriées'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Profile',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
              },
            ),
          ],
        ),
        body: StreamBuilder<List<Plant>>(
          stream: readPlants(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: ElevatedButton.icon(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
                                ))
                          },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajoutez une nouvelle graine')),
                );
              }
              final plants = snapshot.data!;
              plants.sort((a, b) => a.nom.compareTo(b.nom));
              return ListView(
                children: plants.map((plant) => buildPlant(plant)).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );

  Widget buildPlant(Plant plant) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPlantPage(currentPlant: plant)));
      },
      title: Text(plant.nom),
      subtitle: Text(plant.category),
      leading: plant.isSeedlingUnderGreenhouse == true
          ? const Icon(
              Icons.compost,
              color: Colors.green,
            )
          : const Icon(
              Icons.compost,
              color: Colors.red,
            ),
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });
  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}
