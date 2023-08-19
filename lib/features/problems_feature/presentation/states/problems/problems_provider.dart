import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'problems_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/problems_repo.dart';
import '../../../data/models/problem_model.dart';
import '../../../data/models/problems_page_model.dart';

final problemsProvider = StateNotifierProvider<
    ProblemsNotifier,
    ProblemsState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return ProblemsNotifier(client);
});

class ProblemsNotifier extends StateNotifier<ProblemsState> {

  ProblemsNotifier(this.client) : super(InitProblemsState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final ProblemsRepoImp repo = ProblemsRepoImp(client);

  Future<void> getAllProblems() async {
    state = LoadingProblemsState();
    final response = await repo.getProblems(1, 10000);
    state = _mapFailureOrProblemsToState(response);
  }

  Future<void> createProblem(ProblemModel problem) async {
    state = LoadingProblemsState();
    final response = await repo.createProblem(problem);
    state = _mapFailureOrSuccessToState(response);
    if (state is SuccessProblemsState) {
      await getAllProblems();
    }
  }

  Future<void> deleteProblemType(int id) async {
    state = LoadingProblemsState();
    final response = await repo.deleteProblem(id);
    state = _mapFailureOrSuccessToState(response);
    if (state is SuccessProblemsState) {
      await getAllProblems();
    }
  }

  ProblemsState _mapFailureOrProblemsToState(Either<Failure, ProblemsPageModel> either) {
    return either.fold(
      (failure) => ErrorProblemsState(message: _mapFailureToMessage(failure)),
      (page) => LoadedProblemsState(page: page),
    );
  }

  ProblemsState _mapFailureOrSuccessToState(Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorProblemsState(message: _mapFailureToMessage(failure)),
      (success) => SuccessProblemsState(message: success),
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