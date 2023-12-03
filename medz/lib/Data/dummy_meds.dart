import 'package:medz/Classes/Medicine.dart';

final dummyMeds = [
  Medicine(
      name: 'Panadol',
      expiryDate: DateTime.now().add(
        const Duration(days: 300),
      ),
      dozes: 3),
  Medicine(
      name: 'Antinal',
      expiryDate: DateTime.now().add(
        const Duration(days: 200),
      ),
      dozes: 4),
  Medicine(
      name: 'Profin',
      expiryDate: DateTime.now().add(
        const Duration(days: 100),
      ),
      dozes: 2),
];
