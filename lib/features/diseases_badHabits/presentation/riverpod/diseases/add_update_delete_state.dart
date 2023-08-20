import 'package:equatable/equatable.dart';

abstract class AddDeleteUpdateDiseasesState extends Equatable {
  const AddDeleteUpdateDiseasesState();

  @override
  List<Object> get props => [];
}

class AddDeleteUpdateDiseasesInitial extends AddDeleteUpdateDiseasesState {}

class LoadingAddDeleteUpdateDiseasesState
    extends AddDeleteUpdateDiseasesState {}

class ErrorAddDeleteUpdateDiseasesState extends AddDeleteUpdateDiseasesState {
  final String message;

  const ErrorAddDeleteUpdateDiseasesState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdateDiseasesState extends AddDeleteUpdateDiseasesState {
  final String message;

  const MessageAddDeleteUpdateDiseasesState({required this.message});

  @override
  List<Object> get props => [message];
}
