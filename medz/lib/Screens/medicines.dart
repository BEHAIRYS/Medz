import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:medz/Classes/Medicine.dart';
import 'package:medz/Providers/MedicineProvider.dart';
import 'package:medz/Screens/auth.dart';

import 'package:medz/Screens/mainScreen.dart';
import 'package:medz/Widgets/medItem.dart';

class Medicines extends StatefulWidget {
  const Medicines({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Medicines_state();
  }
}

final _firebase = FirebaseAuth.instance;
final DatabaseReference _database = FirebaseDatabase.instance.ref();
User? user = _firebase.currentUser;

class _Medicines_state extends State<Medicines> {
  @override
  Widget build(BuildContext context) {
    final medList = Provider.of<MedicineProvider>(context).medicines;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return MainScreen();
                }),
              );
            },
            icon: const Icon(Icons.add)),
        title: const Text('Abohmedz'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return const AuthScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: getMedicines(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            medList.clear();
            Map<dynamic, dynamic>? data =
                (snapshot.data!.snapshot.value as Map<dynamic, dynamic>?);
            if (data != null) {
              data.forEach((key, value) {
                var medicine = Medicine(
                  name: value['name'],
                  expiryDate: DateTime.parse(value['expiryDate']),
                  dozes: value['dose'],
                );
                medList.add(medicine);
              });
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: medList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Card(
                            child: MedItem(
                              med: medList.elementAt(index),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Stream<DatabaseEvent> getMedicines() {
    return _database.child('users').child(user!.uid).child('medicines').onValue;
  }
}
