import 'package:equatable/equatable.dart';
import '../../../data/models/treatment_model.dart';

abstract class TreatmentState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitTreatmentState extends TreatmentState {}

class LoadingTreatmentState extends TreatmentState {}

class LoadedTreatmentState extends TreatmentState {
  late final TreatmentModel treatment;

  LoadedTreatmentState({required this.treatment});

  @override
  List<Object> get props => [treatment];
}

class ErrorTreatmentState extends TreatmentState {
  late final String message;

  ErrorTreatmentState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessTreatmentState extends TreatmentState {
  late final String message;

  SuccessTreatmentState({required this.message});

  @override
  List<Object> get props => [message];
}