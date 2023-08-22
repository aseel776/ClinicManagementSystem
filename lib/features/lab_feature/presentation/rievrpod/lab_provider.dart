import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';

import '../../data/models/lab_table_model.dart';
import '../../data/repository/lab_repository.dart';
import 'lab_state.dart';

final labsProvider = StateNotifierProvider<LabsNotifier, LabsState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return LabsNotifier(client: client);
  },
);

class LabsNotifier extends StateNotifier<LabsState> {
  GraphQLClient client;
  LabsNotifier({required this.client}) : super(LabsInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the functions
  final LabRepositoryImpl repositoryImpl = LabRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<void> getPaginatedLabs(double itemPerPage, double page) async {
    state = LoadingLabsState();
    final response = await repositoryImpl.getPaginatedLabs(itemPerPage, page);
    state = _mapFailureOrLabsToState(response);
  }

  Future<void> getPaginatedSearchLabs(
      double itemPerPage, double page, String searchText) async {
    state = LoadingLabsState();
    final response = await repositoryImpl.getPaginatedSearchLabs(
        itemPerPage, page, searchText);
    state = _mapFailureOrLabsToState(response);
  }

  LabsState _mapFailureOrLabsToState(Either<Failure, LabTable> either) {
    return either.fold(
      (failure) => ErrorLabsState(message: _mapFailureToMessage(failure)),
      (labs) => LoadedLabsState(labs: labs.labs, totalPages: labs.totalPages),
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
