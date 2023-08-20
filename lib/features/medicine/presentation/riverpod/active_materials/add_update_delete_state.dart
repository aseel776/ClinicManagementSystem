import 'package:equatable/equatable.dart';

abstract class AddDeleteUpdateActiveMaterialsState extends Equatable {
  const AddDeleteUpdateActiveMaterialsState();

  @override
  List<Object> get props => [];
}

class AddDeleteUpdateActiveMaterialsInitial
    extends AddDeleteUpdateActiveMaterialsState {}

class LoadingAddDeleteUpdateActiveMaterialsState
    extends AddDeleteUpdateActiveMaterialsState {}

class ErrorAddDeleteUpdateActiveMaterialsState
    extends AddDeleteUpdateActiveMaterialsState {
  final String message;

  const ErrorAddDeleteUpdateActiveMaterialsState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdateActiveMaterialsState
    extends AddDeleteUpdateActiveMaterialsState {
  final String message;

  const MessageAddDeleteUpdateActiveMaterialsState({required this.message});

  @override
  List<Object> get props => [message];
}
