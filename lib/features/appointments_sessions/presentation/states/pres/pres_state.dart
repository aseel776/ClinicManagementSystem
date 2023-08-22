import 'package:equatable/equatable.dart';
import '../../../data/models/pres_input_model.dart';

abstract class PrescriptionState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitPrescriptionState extends PrescriptionState {}

class LoadingPrescriptionState extends PrescriptionState {}

class LoadedPrescriptionState extends PrescriptionState {
  late final List<PrescriptionInput> meds;

  LoadedPrescriptionState({required this.meds});

  @override
  List<Object> get props => [meds];
}

class ErrorPrescriptionState extends PrescriptionState {
  late final String message;

  ErrorPrescriptionState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessPrescriptionState extends PrescriptionState {
  late final String message;

  SuccessPrescriptionState({required this.message});

  @override
  List<Object> get props => [message];
}