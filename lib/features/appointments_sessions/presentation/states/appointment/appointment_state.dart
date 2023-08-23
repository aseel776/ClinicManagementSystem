import 'package:equatable/equatable.dart';
import '../../../data/models/appointment_model.dart';

abstract class AppointmentState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitAppointmentState extends AppointmentState {}

class LoadingAppointmentState extends AppointmentState {}

class LoadedAppointmentState extends AppointmentState {
  late final AppointmentModel app;

  LoadedAppointmentState({required this.app});

  @override
  List<Object> get props => [app];
}

class ErrorAppointmentState extends AppointmentState {
  late final String message;

  ErrorAppointmentState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessAppointmentState extends AppointmentState {
  late final String message;

  SuccessAppointmentState({required this.message});

  @override
  List<Object> get props => [message];
}