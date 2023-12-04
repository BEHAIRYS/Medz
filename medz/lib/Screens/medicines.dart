import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medz/Data/dummy_meds.dart';
import 'package:medz/Providers/MedicineProvider.dart';
import 'package:medz/Screens/mainScreen.dart';
import 'package:medz/Widgets/medItem.dart';
import 'package:provider/provider.dart';

class Medicines extends StatefulWidget {
  const Medicines({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Medicines_state();
  }
}

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
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: medList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Card(
                      child: MedItem(
                        med: medList.elementAt(index),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
