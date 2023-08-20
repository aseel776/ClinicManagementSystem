import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';

import '../../data/models/lab_model.dart';
import '../../data/repository/lab_repository.dart';

import 'lab_crud_state.dart';

final labCrudProvider =
    StateNotifierProvider<AddUpdateDeleteLabNotifier, AddDeleteUpdateLabState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return AddUpdateDeleteLabNotifier(client: client);
  },
);

class AddUpdateDeleteLabNotifier
    extends StateNotifier<AddDeleteUpdateLabState> {
  GraphQLClient client;
  AddUpdateDeleteLabNotifier({required this.client})
      : super(AddDeleteUpdateLabInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the Functions
  final LabRepositoryImpl repositoryImpl = LabRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<void> addLab(Lab lab) async {
    state = LoadingAddDeleteUpdateLabState();
    final response = await repositoryImpl.addNewLab(lab);
    state = _eitherDoneMessageOrErrorState(response);
  }

  Future<void> editLab(Lab lab) async {
    state = LoadingAddDeleteUpdateLabState();
    final response = await repositoryImpl.editLab(lab);
    state = _eitherDoneMessageOrErrorState(response);
  }

  Future<void> deleteLab(Lab lab) async {
    state = LoadingAddDeleteUpdateLabState();
    final response = await repositoryImpl.deleteLab(lab);
    state = _eitherDoneMessageOrErrorState(response);
  }

  AddDeleteUpdateLabState _eitherDoneMessageOrErrorState(
      Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateLabState(
        message: _mapFailureToMessage(failure),
      ),
      (message) => MessageAddDeleteUpdateLabState(message: message),
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
