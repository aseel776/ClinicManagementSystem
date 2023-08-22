import 'package:intl/intl.dart';

class PatientCost {
  final int? id;
  final String? date;
  final String? treatment;
  final int? amount;
  final int? treatmentId;

  PatientCost(
      {this.id, this.date, this.treatment, this.amount, this.treatmentId});

  factory PatientCost.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['date']);
    String formattedDate = DateFormat("dd/MM/yyyy").format(parsedDate);
    return PatientCost(
      id: json['id'] as int,
      date: formattedDate,
      // treatment: json['treatment'] as String,
      treatment: null,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'treatment': treatment,
      'amount': amount,
    };
  }
}
