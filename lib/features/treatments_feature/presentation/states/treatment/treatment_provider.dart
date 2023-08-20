import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './treatment_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/treatment_repo.dart';
import '../../../data/models/treatment_model.dart';

final treatmentProvider = StateNotifierProvider<
    TreatmentNotifier,
    TreatmentState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return TreatmentNotifier(client);
});

class TreatmentNotifier extends StateNotifier<TreatmentState> {
  GraphQLClient client;

  TreatmentNotifier(this.client) : super(InitTreatmentState());

  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final TreatmentRepoImp repo = TreatmentRepoImp(client);

  Future<void> getTreatment(int id) async {
    state = LoadingTreatmentState();
    final response = await repo.getTreatment(id);
    state = _mapFailureOrTreatmentToState(response);
  }

  Future<void> updateTreatment(TreatmentModel body) async {
    state = LoadingTreatmentState();
    final response = await repo.updateTreatment(body);
    state = _mapFailureOrSuccessToState(response);
  }

  TreatmentState _mapFailureOrTreatmentToState(
      Either<Failure, TreatmentModel> either) {
    return either.fold(
      (failure) => ErrorTreatmentState(message: _mapFailureToMessage(failure)),
      (treatment) => LoadedTreatmentState(treatment: treatment),
    );
  }

  TreatmentState _mapFailureOrSuccessToState(Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorTreatmentState(message: _mapFailureToMessage(failure)),
      (success) => SuccessTreatmentState(message: success),
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
