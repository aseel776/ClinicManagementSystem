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
  TreatmentTypesNotifier(this.client) : super (InitTreatmentTypesState());

  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final TreatmentTypesRepoImp repo = TreatmentTypesRepoImp(client);

  Future<void> getAllTreatmentsTypes() async {
    state = LoadingTreatmentTypesState();
    final response = await repo.getTreatmentTypes();
    state = _mapFailureOrTypesToState(response);
  }

  Future<void> createTreatmentType(String name) async {
        state = LoadingTreatmentTypesState();
    final response = await repo.createTreatmentType(name);
    state = _mapFailureOrSuccessToState(response);
    if(state is SuccessTreatmentTypesState){
      await getAllTreatmentsTypes();
    }
  }

  Future<void> updateTreatmentType(TreatmentTypeModel body) async {
    state = LoadingTreatmentTypesState();
    final response = await repo.updateTreatmentType(body);
    state = _mapFailureOrSuccessToState(response);
    if(state is SuccessTreatmentTypesState){
      await getAllTreatmentsTypes();
    }
  }

  Future<void> deleteTreatmentType(int typeId) async {
    state = LoadingTreatmentTypesState();
    final response = await repo.deleteTreatmentType(typeId);
    state = _mapFailureOrSuccessToState(response);
    if(state is SuccessTreatmentTypesState){
      await getAllTreatmentsTypes();
    }
  }

  TreatmentTypesState _mapFailureOrTypesToState(Either<Failure, List<TreatmentTypeModel>> either) {
    return either.fold(
      (failure) => ErrorTreatmentTypesState(message: _mapFailureToMessage(failure)),
      (types) => LoadedTreatmentTypesState(types: types),
    );
  }

  TreatmentTypesState _mapFailureOrSuccessToState(Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorTreatmentTypesState(message: _mapFailureToMessage(failure)),
      (success) => SuccessTreatmentTypesState(message: success),
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