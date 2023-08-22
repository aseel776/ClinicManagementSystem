import 'package:equatable/equatable.dart';
import '../../data/models/patient.dart'; // Import your Patient model

abstract class PatientsState extends Equatable {
  @override
  List<Object?> get props => [];

  get patients => null;
}

class PatientsInitial extends PatientsState {}

class LoadingPatientsState extends PatientsState {}

class LoadedPatientsState extends PatientsState {
  final int? totalPages;
  final List<Patient> patients;

  LoadedPatientsState({required this.patients, this.totalPages});

  @override
  List<Object?> get props => [patients];
}

class SuccessPatientState extends PatientsState {
  final String message;

  SuccessPatientState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ErrorPatientsState extends PatientsState {
  final String message;

  ErrorPatientsState({required this.message});

  @override
  List<Object?> get props => [message];
}
