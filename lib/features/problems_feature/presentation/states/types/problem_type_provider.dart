import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'problem_type_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/problems_types_repo.dart';
import '../../../data/models/problem_type_model.dart';

final problemTypesProvider = StateNotifierProvider<
    ProblemTypesNotifier, ProblemTypesState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return ProblemTypesNotifier(client);
});

class ProblemTypesNotifier extends StateNotifier<ProblemTypesState> {

  ProblemTypesNotifier(this.client) : super(InitProblemTypesState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final ProblemTypesRepoImp repo = ProblemTypesRepoImp(client);

  Future<void> getAllTypes() async {
    state = LoadingProblemTypesState();
    final response = await repo.getProblemTypes();
    state = _mapFailureOrTypesToState(response);
  }

  Future<void> createProblemType(String name) async {
    state = LoadingProblemTypesState();
    final response = await repo.createProblemType(name);
    state = _mapFailureOrSuccessToState(response);
    if(state is SuccessProblemTypesState){
      await getAllTypes();
    }
  }

  Future<void> updateProblemType(ProblemTypeModel body) async {
    state = LoadingProblemTypesState();
    final response = await repo.updateProblemType(body);
    state = _mapFailureOrSuccessToState(response);
    if (state is SuccessProblemTypesState) {
      await getAllTypes();
    }
  }

  Future<void> deleteProblemType(int typeId) async {
    state = LoadingProblemTypesState();
    final response = await repo.deleteProblemType(typeId);
    state = _mapFailureOrSuccessToState(response);
    if (state is SuccessProblemTypesState) {
      await getAllTypes();
    }
  }

  ProblemTypesState _mapFailureOrTypesToState(Either<Failure, List<ProblemTypeModel>> either) {
    return either.fold(
      (failure) => ErrorProblemTypesState(message: _mapFailureToMessage(failure)),
      (types) => LoadedProblemTypesState(types: types),
    );
  }

  ProblemTypesState _mapFailureOrSuccessToState(
      Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorProblemTypesState(message: _mapFailureToMessage(failure)),
      (success) => SuccessProblemTypesState(message: success),
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