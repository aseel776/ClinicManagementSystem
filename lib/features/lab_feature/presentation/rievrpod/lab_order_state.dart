import 'package:equatable/equatable.dart';

import '../../data/models/lab_order.dart';

abstract class LabOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LabOrdersInitial extends LabOrdersState {}

class LoadingLabOrdersState extends LabOrdersState {}

class LoadedLabOrdersState extends LabOrdersState {
  final int? totalPages;
  final List<LabOrder> labOrders; // Replace with the actual Lab Order model

  LoadedLabOrdersState({required this.labOrders, this.totalPages});

  @override
  List<Object?> get props => [labOrders];
}

class ErrorLabOrdersState extends LabOrdersState {
  final String message;

  ErrorLabOrdersState({required this.message});

  @override
  List<Object?> get props => [message];
}
