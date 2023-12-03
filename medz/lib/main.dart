import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medz/Classes/NotificationService.dart';
import 'package:medz/Screens/auth.dart';
import 'package:medz/Screens/loadingScreen.dart';
import 'package:medz/Screens/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medz/Screens/medicines.dart';
import 'firebase_options.dart';

import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the local notifications service
  await NotificationService.initialize();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(
            color: Color.fromARGB(255, 1, 35, 63),
          ),
        ),
      ),
      home: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (snapshot.hasData) {
            return const Medicines();
          }
          return const AuthScreen();
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
