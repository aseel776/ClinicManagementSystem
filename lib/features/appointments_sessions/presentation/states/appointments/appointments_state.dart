import 'package:equatable/equatable.dart';
import '../../../data/models/page_model.dart';

abstract class AppointmentsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitAppointmentsState extends AppointmentsState {}

class LoadingAppointmentsState extends AppointmentsState {}

class LoadedAppointmentsState extends AppointmentsState {
  late final AppointmentsPage page;

  LoadedAppointmentsState({required this.page});

  @override
  List<Object> get props => [page];
}





class ErrorAppointmentsState extends AppointmentsState {
  late final String message;

  ErrorAppointmentsState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessAppointmentsState extends AppointmentsState {
  late final String message;

  SuccessAppointmentsState({required this.message});

  @override
  List<Object> get props => [message];
}