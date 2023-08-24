import 'package:clinic_management_system/features/appointments_sessions/data/models/reservation_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/reservations/reservations_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../data/repos/appointments_repo.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';

final reservationsProvider =
    StateNotifierProvider<ReservationsNotifier, ReservationsState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return ReservationsNotifier(client);
});

class ReservationsNotifier extends StateNotifier<ReservationsState> {
  ReservationsNotifier(this.client) : super(InitReservationsState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);
  late final AppointmentsRepoImp repo = AppointmentsRepoImp(client);

  Future<void> getAllReservations() async {
    state = LoadingReservationsState();
    final response = await repo.getAllReservations();
    state = _mapFailureOrReservationsToState(response);
  }

  Future<void> deleteReservation(int id) async {
    state = LoadingReservationsState();
    final response = await repo.deleteReservations(id);
    state = _mapFailureOrSuccessToState(response);
  }

  // Future<void> createReservation(ReservationModel body) async {
  //   state = LoadingReservationsState();
  //   final response = await repo.createReservation(body);
  //   state = _mapFailureOrSuccessToState(response);
  // }

  // Future<void> deleteReservation(int id) async {
  //   state = LoadingReservationsState();
  //   final response = await repo.deleteReservation(id);
  //   state = _mapFailureOrSuccessToState(response);
  // }

  ReservationsState _mapFailureOrReservationsToState(
      Either<Failure, List<ReservationModel>> either) {
    return either.fold(
      (failure) =>
          ErrorReservationsState(message: _mapFailureToMessage(failure)),
      (reservations) => LoadedReservationsState(reservations: reservations),
    );
  }

  ReservationsState _mapFailureOrSuccessToState(
      Either<Failure, String> either) {
    return either.fold(
      (failure) =>
          ErrorReservationsState(message: _mapFailureToMessage(failure)),
      (success) => SuccessReservationsState(message: success),
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
