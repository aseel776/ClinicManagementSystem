import 'package:equatable/equatable.dart';

abstract class AddDeleteUpdateBadHabitsState extends Equatable {
  const AddDeleteUpdateBadHabitsState();

  @override
  List<Object> get props => [];
}

class AddDeleteUpdateBadHabitsInitial extends AddDeleteUpdateBadHabitsState {}

class LoadingAddDeleteUpdateBadHabitsState
    extends AddDeleteUpdateBadHabitsState {}

class ErrorAddDeleteUpdateBadHabitsState extends AddDeleteUpdateBadHabitsState {
  final String message;

  const ErrorAddDeleteUpdateBadHabitsState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdateBadHabitsState
    extends AddDeleteUpdateBadHabitsState {
  final String message;

  const MessageAddDeleteUpdateBadHabitsState({required this.message});

  @override
  List<Object> get props => [message];
}
