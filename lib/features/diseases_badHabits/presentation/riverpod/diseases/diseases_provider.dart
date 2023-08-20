import 'package:clinic_management_system/features/diseases_badHabits/data/models/diseases_table.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';

import '../../../data/repositories/diseases_repository.dart';
import 'diseases_state.dart';

final diseasesProvider = StateNotifierProvider<DiseasesNotifier, DiseasesState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return DiseasesNotifier(client: client);
  },
);

class DiseasesNotifier extends StateNotifier<DiseasesState> {
  GraphQLClient client;
  DiseasesNotifier({required this.client}) : super(DiseasesInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the functions
  final DiseaseRepositoryImpl repositoryImpl = DiseaseRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  // Future<void> getAllDiseases() async {
  //   state = LoadingDiseasesState();
  //   final response = await repositoryImpl.getDiseases();
  //   state = _mapFailureOrDiseasesToState(response);
  // }

  Future<void> getPaginatedDiseases(double itemPerPage, double page) async {
    state = LoadingDiseasesState();
    final response =
        await repositoryImpl.getPaginatedDiseases(itemPerPage, page);
    state = _mapFailureOrDiseasesToState(response);
  }

  Future<void> getPaginatedSearchDiseases(
      double itemPerPage, double page, String searchText) async {
    state = LoadingDiseasesState();
    final response = await repositoryImpl.getPaginatedSearchDiseases(
        itemPerPage, page, searchText);
    state = _mapFailureOrDiseasesToState(response);
  }

  DiseasesState _mapFailureOrDiseasesToState(
      Either<Failure, DiseasesTable> either) {
    return either.fold(
      (failure) => ErrorDiseasesState(message: _mapFailureToMessage(failure)),
      (diseases) => LoadedDiseasesState(
          diseases: diseases.diseases!, totalPages: diseases.totalPages),
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
