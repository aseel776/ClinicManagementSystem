import 'package:equatable/equatable.dart';
import '../../../data/models/patient_treatment_model.dart';

abstract class PatientTreatmentState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitPatientTreatmentState extends PatientTreatmentState {}

class LoadingPatientTreatmentState extends PatientTreatmentState {}

class LoadedPatientTreatmentState extends PatientTreatmentState {
  late final PatientTreatmentModel patientTreatment;

  LoadedPatientTreatmentState({required this.patientTreatment});

  @override
  List<Object> get props => [patientTreatment];
}

class ErrorPatientTreatmentState extends PatientTreatmentState {
  late final String message;

  ErrorPatientTreatmentState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessPatientTreatmentState extends PatientTreatmentState {
  late final String message;

  SuccessPatientTreatmentState({required this.message});

  @override
  List<Object> get props => [message];
}