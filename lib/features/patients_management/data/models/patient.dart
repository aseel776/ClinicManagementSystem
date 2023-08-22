import 'package:clinic_management_system/features/patients_management/data/models/diseases_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_cost.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_costs_table.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_diagnosis.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_medical_images.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments_table.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import 'badHabits_patient.dart';
import 'medicines_intake.dart';

class Patient extends Equatable {
  int? id;
  String? address;
  DateTime? birthDate;
  String? gender;
  String? job;
  String? mainComplaint;
  String? maritalStatus;
  String? name;
  String? phone;
  List<PatientMedicine> patientMedicines;
  List<PatientBadHabits> patientBadHabits;
  List<PatientDiseases> patientDiseases;
  PatientPaymentsTable? patientPayments;
  PatientCostsTable? patientCosts;
  List<PatientMedicalImage>? patientImages;
  List<PatientDiagnosis>? patientDiagnosis;

  Patient(
      {this.id,
      this.address,
      this.birthDate,
      this.gender,
      this.job,
      this.mainComplaint,
      this.maritalStatus,
      this.name,
      this.phone,
      this.patientMedicines = const [],
      this.patientBadHabits = const [],
      this.patientDiseases = const [],
      this.patientPayments,
      this.patientCosts,
      this.patientImages = const [],
      this.patientDiagnosis = const []});

  factory Patient.fromJson(Map<String, dynamic> json) {
    final patientMedicinesList = (json['patient_medicines'] as List<dynamic>?)
        ?.map((medJson) => PatientMedicine.fromJson(medJson))
        .toList();

    final patientBadHabitsList = (json['patient_badHabits'] as List<dynamic>?)
        ?.map((habitJson) => PatientBadHabits.fromJson(habitJson))
        .toList();

    final patientDiseasesList = (json['patient_diseases'] as List<dynamic>?)
        ?.map((diseaseJson) => PatientDiseases.fromJson(diseaseJson))
        .toList();
    final patientPaymentsList = (json['patient_payments'] as dynamic)
        ?.map((payment) => PatientPaymentsTable.fromJson(payment))
        .toList();
    final patientCostsList = (json['patient_costs'] as dynamic)
        ?.map((cost) => PatientCostsTable.fromJson(cost))
        .toList();

    final patientMedicalImages =
        (json['patient_medical_images'] as List<dynamic>?)
            ?.map((diseaseJson) => PatientMedicalImage.fromJson(diseaseJson))
            .toList();

    final patientDiagnosis = (json['patientDiagnoses'] as List<dynamic>?)
        ?.map((diseaseJson) => PatientDiagnosis.fromJson(diseaseJson))
        .toList();
    return Patient(
        id: json['id'],
        address: json['address'],
        birthDate: json['birth_date'],
        gender: json['gender'],
        job: json.containsKey('job') ? json['job'] : null,
        mainComplaint: json['main_complaint'],
        maritalStatus: json['maintal_status'],
        name: json['name'],
        phone: json['phone'],
        patientMedicines: patientMedicinesList ?? [],
        patientBadHabits: patientBadHabitsList ?? [],
        patientDiseases: patientDiseasesList ?? [],
        patientPayments: patientPaymentsList,
        patientCosts: patientCostsList,
        patientImages: patientMedicalImages,
        patientDiagnosis: patientDiagnosis ?? []);
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat("yyyy-MM-dd");

    final jsonMap = <String, dynamic>{};

    if (address != null) jsonMap['address'] = address;
    if (birthDate != null) {
      jsonMap['birth_date'] = dateFormat.format(birthDate!);
    }
    if (gender != null) jsonMap['gender'] = gender;
    if (job != null) jsonMap['job'] = job;
    if (mainComplaint != null) jsonMap['main_complaint'] = mainComplaint;
    if (maritalStatus != null) jsonMap['maintal_status'] = maritalStatus;
    if (name != null) jsonMap['name'] = name;
    if (phone != null) jsonMap['phone'] = phone;

    if (patientMedicines != null) {
      jsonMap['patient_medicines'] =
          patientMedicines!.map((med) => med.toJson()).toList();
    }

    if (patientBadHabits != null) {
      jsonMap['patient_badHabits'] =
          patientBadHabits!.map((habit) => habit.toJson()).toList();
    }

    if (patientDiseases != null) {
      jsonMap['patient_diseases'] =
          patientDiseases!.map((disease) => disease.toJson()).toList();
    }
    if (patientPayments != null) {
      jsonMap['patient_payments'] = patientPayments!.toJson();
    }
    if (patientCosts != null) {
      jsonMap['patient_costs'] = patientCosts!.toJson();
    }

    return jsonMap;
  }

  @override
  List<Object?> get props => [
        id,
        address,
        birthDate,
        gender,
        job,
        mainComplaint,
        maritalStatus,
        name,
        phone,
        patientMedicines,
        patientBadHabits,
        patientDiseases,
      ];
}
