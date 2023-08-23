import 'package:clinic_management_system/features/appointments_sessions/data/repos/pres_repo.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/pres/pres_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';

final presProvider = StateNotifierProvider<
    PresNotifier,
    PrescriptionState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return PresNotifier(client);
});

class PresNotifier extends StateNotifier<PrescriptionState> {

  PresNotifier(this.client) : super(InitPrescriptionState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final PresRepoImp repo = PresRepoImp(client);

  Future<void> getConflicts(List<int> meds, int patientId) async {
    state = LoadingPrescriptionState();
    final response = await repo.getConflicts(meds, patientId);
    state = _mapFailureOrConflictsToState(response);
  }

  PrescriptionState _mapFailureOrConflictsToState(Either<Failure, List<String>> either) {
    return either.fold(
          (failure) =>
          ErrorPrescriptionState(message: _mapFailureToMessage(failure)),
          (conflicts) => LoadedPrescriptionState(conflicts: conflicts),
    );
  }

  PrescriptionState _mapFailureOrSuccessToState(Either<Failure, String> either) {
    return either.fold(
          (failure) =>
          ErrorPrescriptionState(message: _mapFailureToMessage(failure)),
          (success) => SuccessPrescriptionState(message: success),
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
