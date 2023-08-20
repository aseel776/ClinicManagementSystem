import 'package:clinic_management_system/features/medicine/data/repositories/medicine_repository.dart';

import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';
import 'add_update_delete_state.dart';

final medicinesCrudProvider = StateNotifierProvider<
    AddUpdateDeleteMedicinesNotifier, AddDeleteUpdateMedicinesState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return AddUpdateDeleteMedicinesNotifier(client: client);
  },
);

class AddUpdateDeleteMedicinesNotifier
    extends StateNotifier<AddDeleteUpdateMedicinesState> {
  GraphQLClient client;
  AddUpdateDeleteMedicinesNotifier({required this.client})
      : super(AddDeleteUpdateMedicinesInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  //init repository to call the Functions
  // final MedicineRespositoryImpl respositoryImpl = MedicineRespositoryImpl(
  //     /**************** the 'client cause error here ????'********************* */
  //     GraphQLClient(
  //   link: HttpLink('https://music-mates-fun.herokuapp.com/graphql'),
  //   cache: GraphQLCache(),
  // ));
  final MedicineRespositoryImpl respositoryImpl = MedicineRespositoryImpl(
      /**************** the 'client cause error here ????'********************* */
      GraphQLClient(
    link: HttpLink('http://localhost:3000/graphql'),
    cache: GraphQLCache(),
  ));

  Future<AddDeleteUpdateMedicinesState> addMedicine(Medicine medicine) async {
    state = LoadingAddDeleteUpdateMedicinesState();
    final response = await respositoryImpl.addNewMedicine(medicine);
    AddDeleteUpdateMedicinesState newState =
        _eitherDoneMessageOrErrorState(response);
    state = newState;
    return state;
  }

  Future<AddDeleteUpdateMedicinesState> deleteMedicine(
      Medicine medicine) async {
    state = LoadingAddDeleteUpdateMedicinesState();
    final response = await respositoryImpl.addNewMedicine(medicine);
    AddDeleteUpdateMedicinesState newState =
        _eitherDoneMessageOrErrorState(response);
    state = newState;
    return state;
  }

  AddDeleteUpdateMedicinesState _eitherDoneMessageOrErrorState(
      Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateMedicinesState(
        message: _mapFailureToMessage(failure),
      ),
      (message) => MessageAddDeleteUpdateMedicinesState(message: message),
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
        return "Unexpected Error , Please try again later .";
    }
  }
}
