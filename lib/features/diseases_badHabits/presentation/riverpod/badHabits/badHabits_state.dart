import 'package:equatable/equatable.dart';

import '../../../data/models/badHabits.dart';

abstract class BadHabitsState extends Equatable {
  // const BadHabitsState();

  @override
  List<Object> get props => [];
}

class BadHabitsInitial extends BadHabitsState {}

class LoadingBadHabitsState extends BadHabitsState {}

class LoadedBadHabitsState extends BadHabitsState {
  late final List<BadHabit> badHabits;
  late final int? totalPages;

  LoadedBadHabitsState({required this.badHabits, this.totalPages});

  @override
  List<Object> get props => [badHabits];
}

class ErrorBadHabitsState extends BadHabitsState {
  late final String message;

  ErrorBadHabitsState({required this.message});

  @override
  List<Object> get props => [message];
}
