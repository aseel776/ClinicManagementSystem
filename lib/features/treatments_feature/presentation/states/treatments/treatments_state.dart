import 'package:equatable/equatable.dart';
import '../../../data/models/treatment_model.dart';

abstract class TreatmentsState extends Equatable{
  @override
  List<Object> get props => [];
}

class InitTreatmentsState extends TreatmentsState{}

class LoadingTreatmentsState extends TreatmentsState{}

class LoadedTreatmentsState extends TreatmentsState{
  late final List<TreatmentModel> treatments;
  LoadedTreatmentsState({required this.treatments});

  @override
  List<Object> get props => [treatments];
}

class ErrorTreatmentsState extends TreatmentsState{
  late final String message;
  ErrorTreatmentsState({required this.message});

  @override
  List<Object> get props => [message];
}