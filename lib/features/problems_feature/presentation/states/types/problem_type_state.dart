import 'package:equatable/equatable.dart';
import '../../../data/models/problem_type_model.dart';

abstract class ProblemTypesState extends Equatable{
  @override
  List<Object> get props => [];
}

class InitProblemTypesState extends ProblemTypesState{}

class LoadingProblemTypesState extends ProblemTypesState{}

class LoadedProblemTypesState extends ProblemTypesState{
  final List<ProblemTypeModel> types;
  LoadedProblemTypesState({required this.types});

  @override
  List<Object> get props => [types];
}

class ErrorProblemTypesState extends ProblemTypesState{
  final String message;

  ErrorProblemTypesState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessProblemTypesState extends ProblemTypesState {
  final String message;

  SuccessProblemTypesState({required this.message});

  @override
  List<Object> get props => [message];
}