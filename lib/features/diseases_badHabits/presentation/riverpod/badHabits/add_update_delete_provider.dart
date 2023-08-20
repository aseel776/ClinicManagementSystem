import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/badHabits.dart';
import '../../../data/repositories/badHabits_repository.dart';
import 'add_update_delete_state.dart';

final badHabitsCrudProvider = StateNotifierProvider<
    AddUpdateDeleteBadHabitsNotifier, AddDeleteUpdateBadHabitsState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return AddUpdateDeleteBadHabitsNotifier(client: client);
  },
);

class AddUpdateDeleteBadHabitsNotifier
    extends StateNotifier<AddDeleteUpdateBadHabitsState> {
  GraphQLClient client;
  AddUpdateDeleteBadHabitsNotifier({required this.client})
      : super(AddDeleteUpdateBadHabitsInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the Functions
  final BadHabitRepositoryImpl repositoryImpl = BadHabitRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<void> addBadHabit(BadHabit badHabit) async {
    state = LoadingAddDeleteUpdateBadHabitsState();
    final response = await repositoryImpl.addNewBadHabit(badHabit);
    state = _eitherDoneMessageOrErrorState(response);
  }

  Future<void> editBadHabit(BadHabit badHabit) async {
    state = LoadingAddDeleteUpdateBadHabitsState();
    final response = await repositoryImpl.editBadHabit(badHabit);
    state = _eitherDoneMessageOrErrorState(response);
  }

  Future<void> deleteBadHabit(BadHabit badHabit) async {
    state = LoadingAddDeleteUpdateBadHabitsState();
    final response = await repositoryImpl.deleteBadHabit(badHabit);
    state = _eitherDoneMessageOrErrorState(response);
  }

  AddDeleteUpdateBadHabitsState _eitherDoneMessageOrErrorState(
      Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateBadHabitsState(
        message: _mapFailureToMessage(failure),
      ),
      (message) => MessageAddDeleteUpdateBadHabitsState(message: message),
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
