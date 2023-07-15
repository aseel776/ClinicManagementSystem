import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/treatments_repo.dart';
import '../../../data/models/treatment_model.dart';
import '../../states/treatments/treatments_state.dart';

final treatmentsProvider = StateNotifierProvider<TreatmentsNotifier, TreatmentsState>((ref){
  final client = ref.watch(graphQlClientProvider);
  return TreatmentsNotifier(client);
});

class TreatmentsNotifier extends StateNotifier<TreatmentsState> {
  GraphQLClient client;
  TreatmentsNotifier(this.client) : super(TreatmentsState as TreatmentsState);

  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final TreatmentsRepoImp repo = TreatmentsRepoImp(client);

  Future<TreatmentsState> getAllTreatments() async {
    state = LoadingTreatmentsState();
    final response = await repo.getTreatments();
    TreatmentsState newState = _mapFailureOrTreatmentsToState(response);
    state = newState;
    return state;
  }

  Future<TreatmentsState> createTreatment(TreatmentModel body) async {
    var treatments = state.props as List<TreatmentModel>;
    treatments = [...treatments, body];
    state = LoadingTreatmentsState();
    final response = await repo.createTreatment(body);
    TreatmentsState newState = _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  Future<TreatmentsState> updateTreatment(TreatmentModel body) async {
    state = LoadingTreatmentsState();
    final response = await repo.updateTreatment(body);
    TreatmentsState newState = _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  Future<TreatmentsState> deleteTreatment(int treatmentId) async {
    state = LoadingTreatmentsState();
    final response = await repo.deleteTreatment(treatmentId);
    TreatmentsState newState = _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  TreatmentsState _mapFailureOrTreatmentsToState(Either<Failure, List<TreatmentModel>> either) {
    return either.fold(
      (failure) => ErrorTreatmentsState(message: _mapFailureToMessage(failure)),
      (treatments) => LoadedTreatmentsState(treatments: treatments),
    );
  }

  //Should either return a list<TreatmentModel> from repo with response or handle it here
  TreatmentsState _mapFailureOrSuccessToState(Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorTreatmentsState(message: _mapFailureToMessage(failure)),
      (success) => LoadedTreatmentsState(treatments: <TreatmentModel>[]),
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
