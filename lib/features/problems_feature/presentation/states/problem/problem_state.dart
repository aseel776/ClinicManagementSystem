import 'package:equatable/equatable.dart';
import '../../../data/models/problem_model.dart';

abstract class ProblemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitProblemState extends ProblemState {}

class LoadingProblemState extends ProblemState {}

class LoadedProblemState extends ProblemState {
  final ProblemModel problem;

  LoadedProblemState({required this.problem});

  @override
  List<Object?> get props => [problem];
}

class ErrorProblemState extends ProblemState {
  final String message;

  ErrorProblemState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SuccessProblemState extends ProblemState {
  final String message;

  SuccessProblemState({required this.message});

  @override
  List<Object?> get props => [message];
}