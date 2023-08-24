import 'package:clinic_management_system/features/patients_management/data/models/patient.dart';

class ReservationModel {
  final String date;
  final int id;
  final String notes;
  final int patientId;
  final Patient patient;
  

  ReservationModel(
      {required this.date,
      required this.id,
      required this.notes,
      required this.patientId,
      required this.patient});

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      date: json['date'] as String,
      id: json['id'] as int,
      notes: json['notes'] as String,
      patientId: json['patient_id'] as int,
      patient: Patient.fromJson(json['patient'] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'id': id,
      'notes': notes,
      'patient_id': patientId,
    };
  }
}
