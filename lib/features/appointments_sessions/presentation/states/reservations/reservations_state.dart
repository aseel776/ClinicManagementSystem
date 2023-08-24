import 'package:equatable/equatable.dart';
import '../../../data/models/reservation_model.dart'; // Import the ReservationModel

abstract class ReservationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitReservationsState extends ReservationsState {}

class LoadingReservationsState extends ReservationsState {}

class LoadedReservationsState extends ReservationsState {
  late final List<ReservationModel>
      reservations; // Use ReservationModel instead of AppointmentsPage

  LoadedReservationsState({required this.reservations});

  @override
  List<Object> get props => [reservations];
}

class ErrorReservationsState extends ReservationsState {
  late final String message;

  ErrorReservationsState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessReservationsState extends ReservationsState {
  late final String message;

  SuccessReservationsState({required this.message});

  @override
  List<Object> get props => [message];
}
