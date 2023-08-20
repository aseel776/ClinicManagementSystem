import 'package:equatable/equatable.dart';
import '../../data/models/patient.dart';

abstract class AddEditDeletePatientState extends Equatable {
  const AddEditDeletePatientState();

  @override
  List<Object> get props => [];
}

class AddEditDeletePatientInitial extends AddEditDeletePatientState {}

class LoadingAddEditDeletePatientState extends AddEditDeletePatientState {}

class ErrorAddEditDeletePatientState extends AddEditDeletePatientState {
  final String message;

  const ErrorAddEditDeletePatientState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddEditDeletePatientState extends AddEditDeletePatientState {
  final String message;

  const MessageAddEditDeletePatientState({required this.message});

  @override
  List<Object> get props => [message];
}

class PatientAddEditDeleteSuccessState extends AddEditDeletePatientState {
  final Patient patient;

  const PatientAddEditDeleteSuccessState({required this.patient});

  @override
  List<Object> get props => [patient];
}
