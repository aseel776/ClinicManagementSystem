import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'patient_treatments_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/patient_treatments_repo.dart';
import '../../../data/models/patient_treatment_model.dart';

final patientTreatmentsProvider = StateNotifierProvider<
    PatientTreatmentsNotifier,
    PatientTreatmentsState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return PatientTreatmentsNotifier(client);
});

class PatientTreatmentsNotifier extends StateNotifier<PatientTreatmentsState> {

  PatientTreatmentsNotifier(this.client) : super(InitPatientTreatmentsState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<
      GraphQLClient>(client);
  late final PatientTreatmentsRepoImp repo = PatientTreatmentsRepoImp(client);

  Future<void> getOngoingTreatments(int patientId) async {
    state = LoadingPatientTreatmentsState();
    final response = await repo.getOngoingPatientTreatments(patientId);
    state = _mapFailureOrTreatmentsToState(response);
  }

  Future<void> getPatientTreatments(int id) async {
    state = LoadingPatientTreatmentsState();
    final response = await repo.getAllPatientTreatments(id);
    state = _mapFailureOrTreatmentsToState(response);
  }

  Future<void> createPatientTreatment(PatientTreatmentModel body) async{
    state = LoadingPatientTreatmentsState();
    final response = await repo.createPatientTreatment(body);
    state = _mapFailureOrSuccessToState(response);
  }

  PatientTreatmentsState _mapFailureOrTreatmentsToState(
      Either<Failure, List<PatientTreatmentModel>> either) {
    return either.fold(
          (failure) =>
          ErrorPatientTreatmentsState(message: _mapFailureToMessage(failure)),
          (treats) => LoadedPatientTreatmentsState(treatments: treats),
    );
  }

  PatientTreatmentsState _mapFailureOrSuccessToState(
      Either<Failure, String> either) {
    return either.fold(
          (failure) =>
          ErrorPatientTreatmentsState(message: _mapFailureToMessage(failure)),
          (success) => SuccessPatientTreatmentsState(message: success),
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