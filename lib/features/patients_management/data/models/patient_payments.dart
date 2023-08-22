import 'package:intl/intl.dart';

class PatientPayment {
   int? id;
  final String date;
  final int amount;

  PatientPayment({
    this.id,
    required this.date,
    required this.amount,
  });

  factory PatientPayment.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['date']);
    String formattedDate = DateFormat("dd/MM/yyyy").format(parsedDate);
    return PatientPayment(
      id: json['id'] as int,
      date: formattedDate,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
    };
  }
}
