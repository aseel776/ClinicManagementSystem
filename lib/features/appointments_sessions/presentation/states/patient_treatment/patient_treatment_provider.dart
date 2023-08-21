import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'patient_treatment_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/patient_treatments_repo.dart';
import '../../../data/models/patient_treatment_model.dart';

final patientTreatmentProvider = StateNotifierProvider<
    PatientTreatmentNotifier,
    PatientTreatmentState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return PatientTreatmentNotifier(client);
});

class PatientTreatmentNotifier extends StateNotifier<PatientTreatmentState> {
  PatientTreatmentNotifier(this.client) : super(InitPatientTreatmentState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier =
  ValueNotifier<GraphQLClient>(client);
  late final PatientTreatmentsRepoImp repo = PatientTreatmentsRepoImp(client);

  Future<void> getPatientTreatment(int treatmentId) async {
    state = LoadingPatientTreatmentState();
    final response = await repo.getPatientTreatment(treatmentId);
    state = _mapFailureOrPatientTreatmentToState(response);
  }

  PatientTreatmentState _mapFailureOrPatientTreatmentToState(
      Either<Failure, PatientTreatmentModel> either) {
    return either.fold(
          (failure) =>
          ErrorPatientTreatmentState(message: _mapFailureToMessage(failure)),
          (patientTreatment) =>
          LoadedPatientTreatmentState(patientTreatment: patientTreatment),
    );
  }

  PatientTreatmentState _mapFailureOrSuccessToState(
      Either<Failure, String> either) {
    return either.fold(
          (failure) =>
          ErrorPatientTreatmentState(message: _mapFailureToMessage(failure)),
          (success) => SuccessPatientTreatmentState(message: success),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return SERVER_FAILURE_MESSAGE;
    } else if (failure is EmptyCacheFailure) {
      return EMPTY_CACHE_FAILURE_MESSAGE;
    } else if (failure is OfflineFailure) {
      return OFFLINE_FAILURE_MESSAGE;
    } else {
      return "Unexpected Error, please try again later.";
    }
  }
}