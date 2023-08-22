import 'package:equatable/equatable.dart';

abstract class AddDeleteUpdateLabOrderState extends Equatable {
  const AddDeleteUpdateLabOrderState();

  @override
  List<Object> get props => [];
}

class AddDeleteUpdateLabOrderInitial extends AddDeleteUpdateLabOrderState {}

class LoadingAddDeleteUpdateLabOrderState
    extends AddDeleteUpdateLabOrderState {}

class ErrorAddDeleteUpdateLabOrderState extends AddDeleteUpdateLabOrderState {
  final String message;

  const ErrorAddDeleteUpdateLabOrderState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdateLabOrderState extends AddDeleteUpdateLabOrderState {
  final String message;

  const MessageAddDeleteUpdateLabOrderState({required this.message});

  @override
  List<Object> get props => [message];
}
