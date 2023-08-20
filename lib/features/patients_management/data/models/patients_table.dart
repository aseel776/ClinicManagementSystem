import 'package:clinic_management_system/features/patients_management/data/models/patient.dart';

class PatientsTable {
  final List<Patient>? patients;
  final int? totalPages;

  PatientsTable({required this.patients, this.totalPages});
}
