import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart'; // Import your PatientPayment class

class PatientPaymentsTable {
  List<PatientPayment>? payments;
  int? totalAmounts;

  PatientPaymentsTable({required this.payments, this.totalAmounts});

  factory PatientPaymentsTable.fromJson(Map<String, dynamic> json) {
    return PatientPaymentsTable( 
      payments: (json['payments'] as List<dynamic>)
          .map((paymentJson) => PatientPayment.fromJson(paymentJson))
          .toList(),
      totalAmounts: json['totalAmounts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payments': payments?.map((payment) => payment.toJson()).toList(),
      'totalAmounts': totalAmounts,
    };
  }
}
