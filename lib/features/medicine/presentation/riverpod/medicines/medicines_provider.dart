import 'package:clinic_management_system/features/medicine/data/model/medicine_table.dart';
import 'package:clinic_management_system/features/medicine/data/repositories/medicine_repository.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/medicines_state.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';

final medicinesProvider =
    StateNotifierProvider<MedicinesNotifier, MedicinesState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return MedicinesNotifier(client: client);
  },
);

class MedicinesNotifier extends StateNotifier<MedicinesState> {
  GraphQLClient client;
  MedicinesNotifier({required this.client}) : super(MedicinesInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  //init repository to call the Functions
  final MedicineRespositoryImpl respositoryImpl = MedicineRespositoryImpl(
      /**************** the 'client cause error here ????'********************* */
      GraphQLClient(
    link: HttpLink('http://localhost:3000/graphql'),
    cache: GraphQLCache(),
  ));

  // Future<MedicinesState> getAllMedicines() async {
  //   state = LoadingMedicinesState();
  //   final response = await respositoryImpl.getMedicine();
  //   MedicinesState newState = _mapFailureOrMedicinesToState(response);
  //   state = newState;
  //   return state;
  // }

  Future<void> getPaginatedMedicines(double itemPerPage, double page) async {
    state = LoadingMedicinesState();
    final response =
        await respositoryImpl.getPaginatedMedicines(itemPerPage, page);
    state = _mapFailureOrMedicinesToState(response);
  }

  MedicinesState _mapFailureOrMedicinesToState(
      Either<Failure, MedicinesTable> either) {
    return either.fold(
      (failure) => ErrorMedicinesState(message: _mapFailureToMessage(failure)),
      (medicines) => LoadedMedicinesState(
          medicines: medicines.medicinesList!,
          totalPages: medicines.totalPages),
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
