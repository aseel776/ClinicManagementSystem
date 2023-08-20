import 'package:equatable/equatable.dart';

abstract class AddDeleteUpdateLabState extends Equatable {
  const AddDeleteUpdateLabState();

  @override
  List<Object> get props => [];
}

class AddDeleteUpdateLabInitial extends AddDeleteUpdateLabState {}

class LoadingAddDeleteUpdateLabState extends AddDeleteUpdateLabState {}

class ErrorAddDeleteUpdateLabState extends AddDeleteUpdateLabState {
  final String message;

  const ErrorAddDeleteUpdateLabState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdateLabState extends AddDeleteUpdateLabState {
  final String message;

  const MessageAddDeleteUpdateLabState({required this.message});

  @override
  List<Object> get props => [message];
}
