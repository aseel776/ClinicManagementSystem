import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './treatment_types_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/models/treatment_type_model.dart';
import '../../../data/repos/treatments_types_repo.dart';

final treatmentsTypesProvider = StateNotifierProvider<TreatmentTypesNotifier, TreatmentTypesState>((ref){
  final client = ref.watch(graphQlClientProvider);
  return TreatmentTypesNotifier(client);
});

class TreatmentTypesNotifier extends StateNotifier<TreatmentTypesState> {
  GraphQLClient client;
  TreatmentTypesNotifier(this.client) : super (TreatmentTypesState as TreatmentTypesState);

  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final TreatmentTypesRepoImp repo = TreatmentTypesRepoImp(client);

  Future<TreatmentTypesState> getAllTreatments() async {
    state = LoadingTreatmentTypesState();
    final response = await repo.getTreatmentTypes();
    TreatmentTypesState newState = _mapFailureOrTypesToState(response);
    state = newState;
    return state;
  }

  Future<TreatmentTypesState> createTreatment(TreatmentTypeModel body) async {
    var treatments = state.props as List<TreatmentTypeModel>;
    treatments = [...treatments, body];
    state = LoadingTreatmentTypesState();
    final response = await repo.updateTreatmentType(body);
    TreatmentTypesState newState = _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  Future<TreatmentTypesState> updateTreatment(TreatmentTypeModel body) async {
    state = LoadingTreatmentTypesState();
    final response = await repo.updateTreatmentType(body);
    TreatmentTypesState newState = _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  Future<TreatmentTypesState> deleteTreatment(int typeId) async {
    state = LoadingTreatmentTypesState();
    final response = await repo.deleteTreatmentType(typeId);
    TreatmentTypesState newState = _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  TreatmentTypesState _mapFailureOrTypesToState(Either<Failure, List<TreatmentTypeModel>> either) {
    return either.fold(
          (failure) =>
          ErrorTreatmentTypesState(message: _mapFailureToMessage(failure)),
          (types) => LoadedTreatmentTypesState(types: types),
    );
  }

  //Should either return a list<TreatmentTypeModel> from repo with response or handle it here
  TreatmentTypesState _mapFailureOrSuccessToState(Either<Failure, String> either) {
    return either.fold(
          (failure) =>
          ErrorTreatmentTypesState(message: _mapFailureToMessage(failure)),
          (success) => LoadedTreatmentTypesState(types: <TreatmentTypeModel>[]),
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