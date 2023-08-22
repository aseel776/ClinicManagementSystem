import 'package:clinic_management_system/features/patients_management/data/models/patient_diagnosis.dart';

class PatientDiagnosisTable {
  List<PatientDiagnosis>? diagnosis;
  int? totalPages;

  PatientDiagnosisTable({this.diagnosis, this.totalPages});

  // Convert PatientDiagnosisTable instance to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'diagnosis': diagnosis?.map((diagnosis) => diagnosis.toJson()).toList(),
      'totalPages': totalPages,
    };
  }

  // Create a PatientDiagnosisTable instance from a Map (JSON)
  factory PatientDiagnosisTable.fromJson(Map<String, dynamic> json) {
    return PatientDiagnosisTable(
      diagnosis: (json['diagnosis'] as List<dynamic>?)
          ?.map((diagnosisJson) => PatientDiagnosis.fromJson(diagnosisJson))
          .toList(),
      totalPages: json['totalPages'],
    );
  }
}
