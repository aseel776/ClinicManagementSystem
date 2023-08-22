import 'dart:math';

import 'package:clinic_management_system/features/patients_management/data/models/patient_cost.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart'; // Import your PatientPayment class

class PatientCostsTable {
  List<PatientCost>? costs;
  int? totalAmounts;

  PatientCostsTable({required this.costs, this.totalAmounts});

  factory PatientCostsTable.fromJson(Map<String, dynamic> json) {
    return PatientCostsTable(
      costs: (json['costs'] as List<dynamic>)
          .map((paymentJson) => PatientCost.fromJson(paymentJson))
          .toList(),
      totalAmounts: json['totalAmounts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'costs': costs?.map((payment) => payment.toJson()).toList(),
      'totalAmounts': totalAmounts,
    };
  }
}
