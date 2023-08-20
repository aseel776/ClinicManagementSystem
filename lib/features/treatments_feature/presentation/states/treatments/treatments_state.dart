import 'package:equatable/equatable.dart';
import '../../../data/models/treatments_page_model.dart';

abstract class TreatmentsState extends Equatable{
  @override
  List<Object> get props => [];
}

class InitTreatmentsState extends TreatmentsState{}

class LoadingTreatmentsState extends TreatmentsState{}

class LoadedTreatmentsState extends TreatmentsState{
  late final TreatmentsPageModel page;
  LoadedTreatmentsState({required this.page});

  @override
  List<Object> get props => [page];
}

class ErrorTreatmentsState extends TreatmentsState{
  late final String message;
  ErrorTreatmentsState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessTreatmentsState extends TreatmentsState {
  late final String message;

  SuccessTreatmentsState({required this.message});

  @override
  List<Object> get props => [message];
}