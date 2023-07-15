import 'package:equatable/equatable.dart';
import '../../../data/models/treatment_type_model.dart';

abstract class TreatmentTypesState extends Equatable{
  @override
  List<Object> get props => [];
}

class InitTreatmentTypesState extends TreatmentTypesState {}

class LoadingTreatmentTypesState extends TreatmentTypesState {}

class LoadedTreatmentTypesState extends TreatmentTypesState {
  late final List<TreatmentTypeModel> types;
  LoadedTreatmentTypesState({required this.types});

  @override
  List<Object> get props => [types];
}

class ErrorTreatmentTypesState extends TreatmentTypesState {
  late final String message;
  ErrorTreatmentTypesState({required this.message});

  @override
  List<Object> get props => [message];
}