import 'package:equatable/equatable.dart';
import '../../../data/models/problems_page_model.dart';

abstract class ProblemsState extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitProblemsState extends ProblemsState{}

class LoadingProblemsState extends ProblemsState{}

class LoadedProblemsState extends ProblemsState{
  final ProblemsPageModel page;

  LoadedProblemsState({required this.page});

  @override
  List<Object?> get props => [page];
}

class ErrorProblemsState extends ProblemsState{
  final String message;

  ErrorProblemsState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SuccessProblemsState extends ProblemsState {
  final String message;

  SuccessProblemsState({required this.message});

  @override
  List<Object?> get props => [message];
}