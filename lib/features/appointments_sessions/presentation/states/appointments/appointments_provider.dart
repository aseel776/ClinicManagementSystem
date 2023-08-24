import 'package:clinic_management_system/features/appointments_sessions/data/models/reservation_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'appointments_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/appointments_repo.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/page_model.dart';

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, AppointmentsState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return AppointmentsNotifier(client);
});

class AppointmentsNotifier extends StateNotifier<AppointmentsState> {
  AppointmentsNotifier(this.client) : super(InitAppointmentsState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);
  late final AppointmentsRepoImp repo = AppointmentsRepoImp(client);

  Future<void> getAllAppointments(String date) async {
    state = LoadingAppointmentsState();
    final response = await repo.getAllAppointments(date);
    state = _mapFailureOrAppointmentsToState(response);
  }

  // Future<void> getAllReservations(String date) async {
  //   state = LoadingAppointmentsState();
  //   final response = await repo.getAllReservations();
  //   state = _mapFailureOrAppointmentsToState(response);
  // }

  Future<void> createAppointment(AppointmentModel body) async {
    state = LoadingAppointmentsState();
    final response = await repo.createAppointment(body);
    state = _mapFailureOrSuccessToState(response);
  }

  Future<void> deleteMaterial(int id) async {
    state = LoadingAppointmentsState();
    final response = await repo.deleteAppointment(id);
    state = _mapFailureOrSuccessToState(response);
  }

  AppointmentsState _mapFailureOrAppointmentsToState(
      Either<Failure, AppointmentsPage> either) {
    return either.fold(
      (failure) =>
          ErrorAppointmentsState(message: _mapFailureToMessage(failure)),
      (page) => LoadedAppointmentsState(page: page),
    );
  }

  AppointmentsState _mapFailureOrSuccessToState(
      Either<Failure, String> either) {
    return either.fold(
      (failure) =>
          ErrorAppointmentsState(message: _mapFailureToMessage(failure)),
      (success) => SuccessAppointmentsState(message: success),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error, please try again later.";
    }
  }
}
