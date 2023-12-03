import 'package:intl/intl.dart';

final formatter = DateFormat('yyyy-MM-dd');

class Medicine {
  final String name;
  final DateTime expiryDate;
  final int dozes;

  get date {
    final formattedDate = formatter.format(expiryDate);
    return formattedDate;
  }

  factory Medicine.fromJSON(Map<String, dynamic> json) {
    return Medicine(
        name: json['name'],
        expiryDate: DateFormat("dd/MM/yyyy").parse(json['expiryDate']),
        dozes: int.tryParse(json['dose'])!);
  }
  Medicine({required this.name, required this.expiryDate, required this.dozes});
}
