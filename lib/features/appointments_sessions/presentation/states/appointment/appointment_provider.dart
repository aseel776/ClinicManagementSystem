import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'appointment_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/appointments_repo.dart';
import '../../../data/models/appointment_model.dart';

final appointmentProvider = StateNotifierProvider<
    AppointmentNotifier,
    AppointmentState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return AppointmentNotifier(client);
});

class AppointmentNotifier extends StateNotifier<AppointmentState> {

  AppointmentNotifier(this.client) : super(InitAppointmentState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<
      GraphQLClient>(client);
  late final AppointmentsRepoImp repo = AppointmentsRepoImp(client);

  Future<void> getAppointment(int id) async {
    state = LoadingAppointmentState();
    final response = await repo.getAppointment(id);
    state = _mapFailureOrAppToState(response);
  }

  Future<void> updateAppointment(AppointmentModel body) async {
    state = LoadingAppointmentState();
    final response = await repo.updateAppointment(body);
    state = _mapFailureOrSuccessToState(response);
  }

  AppointmentState _mapFailureOrAppToState(Either<Failure, AppointmentModel> either){
    return either.fold(
            (failure) => ErrorAppointmentState(message: _mapFailureToMessage(failure)),
            (app) => LoadedAppointmentState(app: app),
    );
  }

  AppointmentState _mapFailureOrSuccessToState(
      Either<Failure, String> either) {
    return either.fold(
          (failure) =>
          ErrorAppointmentState(message: _mapFailureToMessage(failure)),
          (success) => SuccessAppointmentState(message: success),
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
