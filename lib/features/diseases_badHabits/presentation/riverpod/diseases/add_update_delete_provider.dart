import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/diseases.dart';
import '../../../data/repositories/diseases_repository.dart';
import 'add_update_delete_state.dart';

final diseasesCrudProvider = StateNotifierProvider<
    AddUpdateDeleteDiseasesNotifier, AddDeleteUpdateDiseasesState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return AddUpdateDeleteDiseasesNotifier(client: client);
  },
);

class AddUpdateDeleteDiseasesNotifier
    extends StateNotifier<AddDeleteUpdateDiseasesState> {
  GraphQLClient client;
  AddUpdateDeleteDiseasesNotifier({required this.client})
      : super(AddDeleteUpdateDiseasesInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the Functions
  final DiseaseRepositoryImpl repositoryImpl = DiseaseRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<void> addDisease(Disease disease) async {
    state = LoadingAddDeleteUpdateDiseasesState();
    final response = await repositoryImpl.addNewDisease(disease);
    state = _eitherDoneMessageOrErrorState(response);
  }

  Future<void> editDisease(Disease disease) async {
    state = LoadingAddDeleteUpdateDiseasesState();
    final response = await repositoryImpl.editDisease(disease);
    state = _eitherDoneMessageOrErrorState(response);
  }

  Future<void> deleteDisease(Disease disease) async {
    state = LoadingAddDeleteUpdateDiseasesState();
    final response = await repositoryImpl.deleteDisease(disease);
    state = _eitherDoneMessageOrErrorState(response);
  }

  AddDeleteUpdateDiseasesState _eitherDoneMessageOrErrorState(
      Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateDiseasesState(
        message: _mapFailureToMessage(failure),
      ),
      (message) => MessageAddDeleteUpdateDiseasesState(message: message),
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
