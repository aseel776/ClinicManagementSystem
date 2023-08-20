import 'package:equatable/equatable.dart';

import '../../../data/models/diseases.dart';

abstract class DiseasesState extends Equatable {
  // const DiseasesState();

  @override
  List<Object> get props => [];
}

class DiseasesInitial extends DiseasesState {}

class LoadingDiseasesState extends DiseasesState {}

class LoadedDiseasesState extends DiseasesState {
  late final int? totalPages;
  late final List<Disease> diseases;

  LoadedDiseasesState({required this.diseases, this.totalPages});

  @override
  List<Object> get props => [diseases];
}

class ErrorDiseasesState extends DiseasesState {
  final String message;

  ErrorDiseasesState({required this.message});

  @override
  List<Object> get props => [message];
}
