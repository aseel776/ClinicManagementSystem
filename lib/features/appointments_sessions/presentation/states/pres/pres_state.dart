import 'package:equatable/equatable.dart';

abstract class PrescriptionState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitPrescriptionState extends PrescriptionState {}

class LoadingPrescriptionState extends PrescriptionState {}

class LoadedPrescriptionState extends PrescriptionState {
  // late final List<PrescriptionInput> meds;
  // late final List<String> conflicts;
  //
  // LoadedPrescriptionState({required this.meds, required this.conflicts});

  late final List<String> conflicts;

  LoadedPrescriptionState({required this.conflicts});

  @override
  List<Object> get props => [conflicts];
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