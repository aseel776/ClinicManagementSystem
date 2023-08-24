import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sessions_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/sessions_repo.dart';
import '../../../data/models/session_model.dart';

final sessionsProvider = StateNotifierProvider<SessionsNotifier, SessionsState>((
    ref) {
  final client = ref.watch(graphQlClientProvider);
  return SessionsNotifier(client);
});

class SessionsNotifier extends StateNotifier<SessionsState> {
  SessionsNotifier(this.client) : super(InitSessionsState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<
      GraphQLClient>(client);
  late final SessionsRepoImp repo = SessionsRepoImp(client);

  // Future<void> getSession(int id) async {
  //   state = LoadingSessionsState();
  //   final response = await repo.getAllSessions(id);
  //   state = _mapFailureOrSessionsToState(response);
  // }

  Future<void> createSession(SessionModel session) async {
    state = LoadingSessionsState();
    final response = await repo.createSession(session);
    state = _mapFailureOrSuccessToState(response);
  }

  SessionsState _mapFailureOrSessionsToState(
      Either<Failure, List<SessionModel>> either) {
    return either.fold(
          (failure) =>
          ErrorSessionsState(message: _mapFailureToMessage(failure)),
          (sessions) => LoadedSessionsState(sessions: sessions),
    );
  }

  SessionsState _mapFailureOrSuccessToState(
      Either<Failure, String> either) {
    return either.fold(
          (failure) =>
          ErrorSessionsState(message: _mapFailureToMessage(failure)),
          (success) => SuccessSessionsState(message: success),
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