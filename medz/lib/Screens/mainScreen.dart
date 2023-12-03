import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medz/Classes/Medicine.dart';
import 'package:medz/Screens/medicineInfo.dart';
import 'package:medz/Widgets/QrScanner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return MainScreen_state();
  }
}

class MainScreen_state extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Abohmedz'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        children: [
          QRCodeScanner(),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return MedicineInfo(
                      med: Medicine(
                          name: 'k', expiryDate: DateTime.now(), dozes: 3),
                    );
                  }),
                );
              },
              child: const Text('MedicineInfo'))
        ],
      ),
    );
  }
}
