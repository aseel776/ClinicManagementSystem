import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';

import '../../data/models/lab_order.dart'; // Make sure to import the correct LabOrder model
import '../../data/repository/lab_order_repository.dart'; // Import the LabOrder repository

import 'lab_order_crud_state.dart'; // Import the LabOrder CRUD state

final labOrderCrudProvider =
    StateNotifierProvider<LabOrderCrudNotifier, AddDeleteUpdateLabOrderState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return LabOrderCrudNotifier(client: client);
  },
);

class LabOrderCrudNotifier extends StateNotifier<AddDeleteUpdateLabOrderState> {
  GraphQLClient client;
  LabOrderCrudNotifier({required this.client})
      : super(AddDeleteUpdateLabOrderInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the Functions
  final LabOrderRepositoryImpl repositoryImpl = LabOrderRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<void> addLabOrder(LabOrder labOrder, List<String> steps) async {
    state = LoadingAddDeleteUpdateLabOrderState();
    final response = await repositoryImpl.addLabOrder(labOrder, steps);
    state = _eitherDoneMessageOrErrorState(response);
  }

  Future<void> editLabOrder(LabOrder labOrder,List<String>steps) async {
    state = LoadingAddDeleteUpdateLabOrderState();
    final response = await repositoryImpl.editLabOrder(labOrder,steps);
    state = _eitherDoneMessageOrErrorState(response);
  }

  Future<void> deleteLabOrder(LabOrder labOrder) async {
    state = LoadingAddDeleteUpdateLabOrderState();
    final response = await repositoryImpl.deleteLabOrder(labOrder);
    state = _eitherDoneMessageOrErrorState(response);
  }

  AddDeleteUpdateLabOrderState _eitherDoneMessageOrErrorState(
      Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateLabOrderState(
        message: _mapFailureToMessage(failure),
      ),
      (message) => MessageAddDeleteUpdateLabOrderState(message: message),
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
