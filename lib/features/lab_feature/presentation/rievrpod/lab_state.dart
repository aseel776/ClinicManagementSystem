import 'package:equatable/equatable.dart';

import '../../data/models/lab_model.dart';

abstract class LabsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LabsInitial extends LabsState {}

class LoadingLabsState extends LabsState {}

class LoadedLabsState extends LabsState {
  final int? totalPages;
  final List<Lab> labs;

  LoadedLabsState({required this.labs, this.totalPages});

  @override
  List<Object?> get props => [labs];
}

class ErrorLabsState extends LabsState {
  final String message;

  ErrorLabsState({required this.message});

  @override
  List<Object?> get props => [message];
}
