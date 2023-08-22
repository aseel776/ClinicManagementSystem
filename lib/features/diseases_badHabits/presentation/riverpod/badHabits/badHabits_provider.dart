import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/badHabits.dart';
import '../../../data/models/badhabits_table.dart';
import '../../../data/repositories/badHabits_repository.dart';
import 'badHabits_state.dart';

final badHabitsProvider =
    StateNotifierProvider<BadHabitsNotifier, BadHabitsState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return BadHabitsNotifier(client: client);
  },
);

class BadHabitsNotifier extends StateNotifier<BadHabitsState> {
  GraphQLClient client;
  BadHabitsNotifier({required this.client}) : super(BadHabitsInitial());

  // late final ValueNotifier<GraphQLClient> clientNotifier =
  //     ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the functions
  final BadHabitRepositoryImpl repositoryImpl = BadHabitRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  // Future<void> getAllBadHabits() async {
  //   state = LoadingBadHabitsState();
  //   final response = await repositoryImpl.getBadHabits();
  //   state = _mapFailureOrBadHabitsToState(response);
  // }

  Future<void> getPaginatedBadHabits(double itemPerPage, double page) async {
    state = LoadingBadHabitsState();
    final response =
        await repositoryImpl.getPaginatedBadHabits(itemPerPage, page);
    state = _mapFailureOrBadHabitsToState(response);
  }

  Future<void> getPaginatedSearchBadHabits(
      double itemPerPage, double page, String search) async {
    state = LoadingBadHabitsState();
    final response = await repositoryImpl.getPaginatedSearchBadHabits(
        itemPerPage, page, search);
    state = _mapFailureOrBadHabitsToState(response);
  }

  BadHabitsState _mapFailureOrBadHabitsToState(
      Either<Failure, BadHabitsTable> either) {
    return either.fold(
      (failure) => ErrorBadHabitsState(message: _mapFailureToMessage(failure)),
      (badHabits) => LoadedBadHabitsState(
          badHabits: badHabits.badHabits!, totalPages: badHabits.totalPages),
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
        return "Unexpected Error, Please try again later.";
    }
  }
}
