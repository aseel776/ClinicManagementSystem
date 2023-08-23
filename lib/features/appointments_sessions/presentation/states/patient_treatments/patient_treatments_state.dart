import 'package:clinic_management_system/features/appointments_sessions/data/models/patient_treatment_model.dart';
import 'package:equatable/equatable.dart';

abstract class PatientTreatmentsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitPatientTreatmentsState extends PatientTreatmentsState {}

class LoadingPatientTreatmentsState extends PatientTreatmentsState {}

class LoadedPatientTreatmentsState extends PatientTreatmentsState {
  late final List<PatientTreatmentModel> treatments;

  LoadedPatientTreatmentsState({required this.treatments});

  @override
  List<Object> get props => [treatments];
}

class ErrorPatientTreatmentsState extends PatientTreatmentsState {
  late final String message;

  ErrorPatientTreatmentsState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessPatientTreatmentsState extends PatientTreatmentsState {
  late final String message;

  SuccessPatientTreatmentsState({required this.message});

  @override
  List<Object> get props => [message];
}