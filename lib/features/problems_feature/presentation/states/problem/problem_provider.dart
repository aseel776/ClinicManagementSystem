import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'problem_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/problem_repo.dart';
import '../../../data/models/problem_model.dart';

final problemProvider = StateNotifierProvider<ProblemNotifier, ProblemState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return ProblemNotifier(client);
});

class ProblemNotifier extends StateNotifier<ProblemState> {

  ProblemNotifier(this.client) : super(InitProblemState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final ProblemRepoImp repo = ProblemRepoImp(client);

  Future<void> getProblem(int id) async {
    state = LoadingProblemState();
    final response = await repo.getProblem(id);
    state = _mapFailureOrProblemToState(response);
  }

  Future<void> updateProblem(ProblemModel body) async {
    state = LoadingProblemState();
    final response = await repo.updateProblem(body);
    state = _mapFailureOrSuccessToState(response);
  }

  ProblemState _mapFailureOrProblemToState(
      Either<Failure, ProblemModel> either) {
    return either.fold(
      (failure) => ErrorProblemState(message: _mapFailureToMessage(failure)),
      (problem) => LoadedProblemState(problem: problem),
    );
  }

  ProblemState _mapFailureOrSuccessToState(Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorProblemState(message: _mapFailureToMessage(failure)),
      (success) => SuccessProblemState(message: success),
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