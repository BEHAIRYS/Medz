import 'package:flutter/material.dart';
import 'package:medz/Classes/Medicine.dart';

class MedicineProvider with ChangeNotifier {
  final List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;

  void addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }
}
